TF_VAR_pub_key 			:= $(shell cat ./ec2-key.pub)
ANSIBLE_ROLES_PATH 	:= ./ansible/roles
ANSIBLE_CONFIG 			:= ./ansible/ansible.cfg

export VPN_NAME VPN_USER VPN_PASSWORD
export ANSIBLE_CONFIG ANSIBLE_ROLES_PATH
export TF_VAR_profile TF_VAR_pub_key


# An implicit guard target, used by other targets to ensure
# that environment variables are set before beginning tasks
assert-%:
	@ if [ "${${*}}" = "" ] ; then 								\
	    echo "Environment variable $* not set" ; 	\
	    exit 1 ; 																	\
	fi

vpn:
	@read -p "Enter AWS Profile Name: " profile ; \
	TF_VAR_aws_profile=$$profile make keypair && 	\
	TF_VAR_aws_profile=$$profile make apply && 		\
	TF_VAR_aws_profile=$$profile make reprovision


require-vault:
	aws-vault --version &> /dev/null

require-ansible:
	ansible --version &> /dev/null

require-tf: require-vault
	aws-vault exec ${profile} --assume-role-ttl=60m -- "/usr/local/bin/terraform" "--version" &> /dev/null
	aws-vault exec ${profile} --assume-role-ttl=60m -- "/usr/local/bin/terraform" "init"

require-jq:
	jq --version &> /dev/null



keypair:
	ssh-keygen -N '' -f ec2-key

ansible-roles:
	ansible-galaxy install -r ./ansible/requirements.yml


plan: assert-TF_VAR_aws_profile require-tf
	aws-vault exec ${profile} --assume-role-ttl=60m -- "/usr/local/bin/terraform" "plan"

apply: assert-TF_VAR_aws_profile require-tf require-ansible ansible-roles
	@ if [ -z "$TF_VAR_pub_key" ] ; then 														\
		echo "\$TF_VAR_pub_key is empty; run 'make keypair' first!"	; \
		exit 1 ; 																											\
	fi
	aws-vault exec $$profile --assume-role-ttl=60m -- "/usr/local/bin/terraform" "apply"

build: apply


ssh: require-tf
	ssh 											\
	 -i ./ec2-key 						\
	 -l ubuntu 								\
	 `aws-vault exec $$profile --assume-role-ttl=60m -- "/usr/local/bin/terraform" "output" "-json" |jq -r ".ip.value"`


plan-destroy: assert-TF_VAR_aws_profile require-tf
	aws-vault exec $$profile --assume-role-ttl=60m -- "/usr/local/bin/terraform" "plan" "-destroy"

destroy: assert-TF_VAR_aws_profile require-tf
	aws-vault exec $$profile --assume-role-ttl=60m -- "/usr/local/bin/terraform" "destroy"

clean: destroy
	rm -rf *.ovpn ec2-key* .terraform terraform.*

reprovision: assert-TF_VAR_aws_profile require-tf require-jq
	ansible-playbook 																																																				\
	 -i `aws-vault exec $$profile --assume-role-ttl=60m -- "/usr/local/bin/terraform" "output" "-json" |jq -r ".ip.value"`, \
	 ./openvpn.yml
