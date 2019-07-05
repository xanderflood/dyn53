package main

import (
	"log"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
	flags "github.com/jessevdk/go-flags"
	"github.com/lixiangzhong/dnsutil"
	"github.com/pkg/errors"
)

type options struct {
	HostedZoneID string `long:"hosted-zone-id" env:"HOSTED_ZONE_ID" description:"ID of the AWS hosted zone containing the record to be updated" required:"true"`
	Hostname     string `long:"hostname"       env:"HOSTNAME"       description:"The hostname of the A record to be updated"                    required:"true"`
}

func main() {
	var err error

	var opts options
	if _, err = flags.Parse(&opts); err != nil {
		log.Fatal(err.Error())
	}

	//get own IP
	var myIPAddress string
	if myIPAddress, err = getPublicIP(); err != nil {
		log.Fatal(err)
	}

	r53 := route53.New(session.Must(session.NewSession(&aws.Config{})))
	input := &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: aws.String(opts.HostedZoneID),
		ChangeBatch: &route53.ChangeBatch{
			Comment: aws.String("automatic update from the dyn53 daemon"),
			Changes: []*route53.Change{
				&route53.Change{
					Action: aws.String("UPSERT"),
					ResourceRecordSet: &route53.ResourceRecordSet{
						Name: aws.String(opts.Hostname),
						Type: aws.String("A"),
						TTL:  aws.Int64(300),
						ResourceRecords: []*route53.ResourceRecord{
							&route53.ResourceRecord{
								Value: aws.String(myIPAddress),
							},
						},
					},
				},
			},
		},
	}
	if _, err = r53.ChangeResourceRecordSets(input); err != nil {
		log.Fatal(err)
	}
}

//OpenDNSResolverHostname is the hostname of the openDNS resolver used to looking up our own IP address
const OpenDNSResolverHostname = "resolver1.opendns.com"

//OpenDNSMyIPHostname is the special hostname that can be sent to openDNS in order to get your own IP address
const OpenDNSMyIPHostname = "myip.opendns.com."

func getPublicIP() (string, error) {
	var dig dnsutil.Dig
	dig.SetDNS(OpenDNSResolverHostname)       //or ns.xxx.com
	answer, err := dig.A(OpenDNSMyIPHostname) // dig google.com @8.8.8.8
	if err != nil {
		return "", errors.Wrap(err, "failed to query with OpenDNS server")
	}

	//openDNS should only ever return one resource record for this query
	if len(answer) != 1 {
		return "", errors.New("multiple resource records - could not resolve own IP")
	}

	return answer[0].A.String(), nil
}
