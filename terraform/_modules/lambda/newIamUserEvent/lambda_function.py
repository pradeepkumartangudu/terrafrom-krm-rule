import os
import boto3
client = boto3.client('iam')


def lambda_handler(event, context):
    user = event['detail']['requestParameters']['userName']
    group = os.environ['group_name']
    attachGroup(user, group)
    return 'Done'


def attachGroup(user, group):
    print "Attaching user " + user + " to group " + group
    response = client.add_user_to_group(
        GroupName=group,
        UserName=user
    )
    print "Attached user " + user + " to group " + group
