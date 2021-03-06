# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
# --------------------------------------------------------------------------------------------

from knack.util import CLIError

def get_resource_id(cmd, resource_group_name, provider_name_space, resource_type, resource):
    """
    Gets the resource id for the resource if name is given.
    """
    from azure.cli.core.commands.client_factory import get_subscription_id
    from msrestazure.tools import is_valid_resource_id, resource_id
    if not is_valid_resource_id(resource):
        return resource_id(
            subscription = get_subscription_id(cmd.cli_ctx),
            resource_group = resource_group_name,
            namespace = provider_name_space,
            type = resource_type,
            name = resource)
    else:
        return resource

def create_dictionary_from_arg_string(values, option_string=None):
    """
    Creates and returns dictionary from a string containing params in KEY=VALUE format.
    """
    params_dict = {}
    for item in values:
        try:
            key, value = item.split('=', 1)
            params_dict[key.lower()] = value
        except ValueError:
            raise CLIError('usage error: {} KEY=VALUE [KEY=VALUE ...]'.format(option_string))
    return params_dict
