#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: newcontent

short_description: Training module.

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: Create file with users content.

options:
    path:
        description: Path to file location on remote host.
        required: true
        type: str
    content:
        description: Content of file.
        required: true
        type: str
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - shtepa_aleksei.netology.my_doc_fragment_name

author:
    - Aleksei Shtepa (@aleksei-shtepa)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  aleksei-shtepa.netology.newcontent:
    path: /tmp/new.tmp
    content: "---"

# pass in a message and have changed true
- name: Test with a message and changed output
  aleksei-shtepa.netology.newcontent:
    path: /tmp/new.tmp
    content: "---"

# fail the module
- name: Test failure of the module
  aleksei-shtepa.netology.newcontent:
    path: fail-me-now
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
file_exist:
    description: Flag of exist file.
    type: bool
    returned: always
content_equal:
    description: Flag of content equal.
    type: bool
    returned: always
'''

from ansible.module_utils.basic import AnsibleModule
from pathlib import Path


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=False, default="fail-me-now")
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        file_exist=False,
        content_equal=False,
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    target = Path(module.params['path'])

    if target.exists():
        result['file_exist'] = True
        try:
            with open(target.absolute(), "r") as f:
                exist_content = f.read()
                if exist_content == module.params.get('content', ""):
                    result['content_equal'] = True
        except Exception as ex:
            module.fail_json(msg=f"Put file is faild: {ex}", **result)

    if module.check_mode:
        module.exit_json(**result)

    if module.params['path'] == module.params['content'] == 'fail-me-now':
        module.fail_json(msg="Put file is faild.", **result)

    if not result['file_exist'] or (result['file_exist'] and not result['content_equal']):
        try:
            with open(target.absolute(), "w") as f:
                f.write(module.params.get('content', ""))
        except Exception as ex:
            module.fail_json(msg=f"Put file is faild: {ex}", **result)

        result['changed'] = True

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
