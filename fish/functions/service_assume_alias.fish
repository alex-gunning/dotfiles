#!/usr/bin/env fish

function service_assume_alias --argument-names 'pod' 'role_arn'
  if test (count $argv) -lt 1; or test $argv[1] = "--help"
    echo "Usage: service_assume_alias RUNNING_POD AWS_ROLE_ARN"
    return
  end

  set ran (random)
  set irp_cred_file "/tmp/irp-cred-$ran.txt"

  echo "Get token file from $pod"

  set token_file (kubectl exec -it $pod -- sh -c 'cat $AWS_WEB_IDENTITY_TOKEN_FILE')
  #set aws_role_arn (kubectl exec -it $pod -- sh -c 'printenv AWS_ROLE_ARN')

  echo "Create IRP credentials file in $irp_cred_file"
  aws sts assume-role-with-web-identity --role-arn $role_arn --role-session-name alex_debug_$ran --web-identity-token $token_file --duration-seconds 1000 > $irp_cred_file
  
  echo "You can now export the following ENVs:"
  echo export AWS_DEFAULT_REGION=eu-west-1
  echo export AWS_ROLE_ARN=$argv[2]
  echo export AWS_ACCESS_KEY_ID=(cat $irp_cred_file | jq -r ".Credentials.AccessKeyId")
  echo export AWS_SECRET_ACCESS_KEY=(cat $irp_cred_file | jq -r ".Credentials.SecretAccessKey")
  echo export AWS_SESSION_TOKEN=(cat $irp_cred_file | jq -r ".Credentials.SessionToken")
end

