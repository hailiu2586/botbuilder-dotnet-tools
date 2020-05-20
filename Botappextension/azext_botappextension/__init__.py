import time
from knack.help_files import helps
from operator import itemgetter
from azure.cli.core import AzCommandsLoader, get_default_cli
from azext_botappextension._utils import get_resource_id
from msrestazure.tools import parse_resource_id

def az_cmd(cmd):
    cli = get_default_cli()
    cli.invoke(cmd.split())

    return [cli.result.result, cli.result.error]


def deployBotApp(cmd, resource_group_name, name, source):
    print('deploy botapp')

    # find bot via subscription, group, and botId
    bot_res_id = get_resource_id(
        cmd,
        resource_group_name,
        'Microsoft.BotService',
        'bots',
        name)
    bot_res = parse_resource_id(bot_res_id)
    bot_id = bot_res['name']
    sub = bot_res['subscription']
    rg = bot_res['resource_group']

    # find bot app through hostedBy tag 'az bot show -n {botId} -s -g --query tags.hostedBy --output tsv'
    app_res_id, err = az_cmd(f'bot show -n {bot_id} --subscription {sub} -g {rg} --query tags.hostedBy --output tsv')
    assert not(err)

    print(f'found hosting app at {app_res_id}')
    app_res = parse_resource_id(app_res_id)
    app_sub, app_rg, app_name = itemgetter('subscription', 'resource_group', 'name')(app_res)

    # check for staging slot via 'az webapp deployment slot list --ids {appResId} --query [?name=='staging'].id --output tsv'
    staging_res_id, err = az_cmd(f'webapp deployment slot list --ids {app_res_id} --query [?name==\'staging\'].id --output tsv')
    assert not(err)

    print(f'found staging slot {staging_res_id}')

    # check if WEBSITE_RUN_FROM_PACKAGE is set and needs to be removed via 'az webapp config appsettings list -s -g -n --slot staging --query [?name=='WEBSITE_RUN_FROM_PACKAGE'].value --output tsv'
    zip_url, err = az_cmd(f'webapp config appsettings list -s {app_sub} -g {app_rg} -n {app_name} --slot staging --query [?name==\'WEBSITE_RUN_FROM_PACKAGE\'].value --output tsv')

    if zip_url:
        # delete the WEBSITE_RUN_FROM_PACKAGE setting via 'az webapp config appsettings delete --ids {appResId} --slot staging --setting-names WEBSITE_RUN_FROM_PACKAGE
        print(f'delete WEBSITE_RUN_FROM_PACKAGE setting from {app_res_id}')
        _, err = az_cmd(f'webapp config appsettings delete --ids {app_res_id} --slot staging --setting-names WEBSITE_RUN_FROM_PACKAGE')
        assert not(err)
        # wait for the deletion to take effect
        count = 6
        while zip_url and count > 0:
            count = count - 1
            time.sleep(5)
            zip_url, err = az_cmd(f'webapp config appsettings list -s {app_sub} -g {app_rg} -n {app_name} --slot staging --query [?name==\'WEBSITE_RUN_FROM_PACKAGE\'].value --output tsv')

    assert not(err)



    # call 'az webapp deployment source config-zip --slot staging --src {zipFile}...' to deploy the new payload
    _, err = az_cmd(f'webapp deployment source config-zip --ids {app_res_id} --slot staging --src {source}')
    assert not(err)

    # swap staging slot into production via 'az webapp slot swap --ids {appResId} --slot staging --target-slot production'
    _, err = az_cmd(f'webapp deployment slot swap --ids {app_res_id} --slot staging --target-slot production')

    assert not(err)

    print('done')

class BotAppCommandsLoader(AzCommandsLoader):

    def __init__(self, cli_ctx=None):
        from azure.cli.core.commands import CliCommandType
        custom_type = CliCommandType(operations_tmpl='azext_botappextension#{}')
        super(BotAppCommandsLoader, self).__init__(cli_ctx=cli_ctx,
                                                       custom_command_type=custom_type)

    def load_command_table(self, args):
        with self.command_group('botapp') as g:
            g.custom_command('deploy', 'deployBotApp')
        return self.command_table

    def load_arguments(self, command):
        from azext_botappextension._params import load_arguments
        load_arguments(self, command)

COMMAND_LOADER_CLS = BotAppCommandsLoader
