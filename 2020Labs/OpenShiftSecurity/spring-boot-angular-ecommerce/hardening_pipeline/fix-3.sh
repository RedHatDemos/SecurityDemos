#!/usr/bin/env bash

###############################################################################
# BEGIN fix (1 / 4) for 'xccdf_org.ssgproject.content_rule_ensure_gpgcheck_repo_metadata'
###############################################################################
(>&2 echo "Remediating rule 1/4: 'xccdf_org.ssgproject.content_rule_ensure_gpgcheck_repo_metadata'")
echo "repo_gpgcheck=1" >> /etc/yum.conf

# END fix for 'xccdf_org.ssgproject.content_rule_ensure_gpgcheck_repo_metadata'


###############################################################################
# BEGIN fix (2 / 4) for 'xccdf_org.ssgproject.content_rule_libreswan_approved_tunnels'
###############################################################################
(>&2 echo "Remediating rule 2/4: 'xccdf_org.ssgproject.content_rule_libreswan_approved_tunnels'")
touch /etc/ipsec.conf /etc/ipsec.d

# END fix for 'xccdf_org.ssgproject.content_rule_libreswan_approved_tunnels'


###############################################################################
# BEGIN fix (3 / 4) for 'xccdf_org.ssgproject.content_rule_accounts_password_set_min_life_existing'
###############################################################################
(>&2 echo "Remediating rule 3/4: 'xccdf_org.ssgproject.content_rule_accounts_password_set_min_life_existing'")
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS    1/g' /etc/login.defs

# END fix for 'xccdf_org.ssgproject.content_rule_accounts_password_set_min_life_existing'


###############################################################################
# BEGIN fix (4 / 4) for 'xccdf_org.ssgproject.content_rule_accounts_password_set_max_life_existing'
###############################################################################
(>&2 echo "Remediating rule 4/4: 'xccdf_org.ssgproject.content_rule_accounts_password_set_max_life_existing'")
sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS    60/g' /etc/login.defs

# END fix for 'xccdf_org.ssgproject.content_rule_accounts_password_set_max_life_existing'

###############################################################################
# BEGIN fix (5 / 5) for 'xccdf_org.ssgproject.content_rule_account_disable_post_pw_expiration
###############################################################################
(>&2 echo "Remediating rule 5/5: 'xccdf_org.ssgproject.content_rule_account_disable_post_pw_expiration'")
sed -i 's/INACTIVE=-1/INACTIVE=0/g' /etc/default/useradd

# END fix for 'xccdf_org.ssgproject.content_rule_account_disable_post_pw_expiration'

