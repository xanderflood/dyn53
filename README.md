Dyn53
=====

Dyn53 provides a teeny alpine-based Docker image that allows you to use Route53 as a dynamic DNS provider.

On any linux machine with docker installed, run the `init` script. You'll be prompted for AWS credentials, a hosted zone id, and the domain whose `A` record should be updated. This will launch a container which, on every 30 minutes, determines your machine's public IP address and updates the record.

