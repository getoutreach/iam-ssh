# iam-ssh

Originally forked from [Fullscreen/iam-authorized-keys-command](https://github.com/Fullscreen/iam-authorized-keys-command/tree/master/existing-user) thanks to work by @stefansundin. This command is a simple wrapper around AWS IAM SSH key storage that, if given an IAM user as an argument will return the SSH public key for that user. Using this, we can call this command from SSH to verify the the user has permission to SSH onto a node. The only cavaet is that the AWS username must be the same as the username on the host. This binary is distributed to the hosts and called from the sshd_config as shown below. This also means each host must have permissions to read SSH public keys from AWS. A sample permission policy is given below.

## Example sshd_config

```
AuthorizedKeysFile none
AuthorizedKeysCommand /path/to/compiled/binary
AuthorizedKeysCommandUser nobody
```

If you still want to be able to use the authorized_keys file for some users,
e.g. in case IAM is experiencing downtime, you can add something like the
following:

```
Match User ubuntu
  AuthorizedKeysFile %h/.ssh/authorized_keys
```

Don't forget to restart the ssh service:

```shell
service ssh restart
```

## IAM Role Permissions

This script needs the following policy to execute properly, so make sure you
apply it to your EC2 Role:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListSSHPublicKeys",
                "iam:GetSSHPublicKey"
            ],
            "Resource": "*"
        }
    ]
}

```

## Deployment

Though this is a simple tool, distribution is still a thing. We use the [`gox`](https://github.com/mitchellh/gox) utility to build for multiple architectures. To build, first install this utility and then run `./build.sh`. This will create the architecture-specific binaries in the corresponding directories under dist.
