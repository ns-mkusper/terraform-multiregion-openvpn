TF_VAR_pub_key 			:= $(shell cat ./ec2-key.pub)
ANSIBLE_ROLES_PATH 	:= ./ansible/roles
ANSIBLE_CONFIG 			:= ./ansible/ansible.cfg

export VPN_NAME VPN_USER VPN_PASSWORD
export ANSIBLE_CONFIG ANSIBLE_ROLES_PATH
export TF_VAR_aws_profile TF_VAR_pub_key
export TF_VAR_dns_name


# An implicit guard target, used by other targets to ensure
# that environment variables are set before beginning tasks
assert-%:
	@ if [ "${${*}}" = "" ] ; then 																						\
	    echo "Environment variable $* not set" ; 															\
	    exit 1 ; 																															\
	fi

vpn:
	@read -p "Enter AWS Profile Name: " profile  ; 														\
	@read -p "Enter R53 Domain Name:  " dns_name ; 														\
	TF_VAR_aws_profile=$$profile TF_VAR_dns_name=$$dns_name make keypair 	&& 	\
	TF_VAR_aws_profile=$$profile TF_VAR_dns_name=$$dns_name make apply 		&& 	\
	TF_VAR_aws_profile=$$profile TF_VAR_dns_name=$$dns_name make reprovision


require-vault:
	aws-vault --version &> /dev/null

require-ansible:
	ansible --version &> /dev/null

require-tf: assert-TF_VAR_aws_profile assert-TF_VAR_dns_name require-vault
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "--version" &> /dev/null
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "init"

require-jq:
	jq --version &> /dev/null



keypair:
	ssh-keygen -N '' -f ec2-key

ansible-roles:
	ansible-galaxy install -r ./ansible/requirements.yml


plan: require-tf
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "plan"

apply: require-tf require-ansible ansible-roles
	@ if [ -z "$TF_VAR_pub_key" ] ; then 																\
		echo "\$TF_VAR_pub_key is empty; run 'make keypair' first!"	; 		\
		exit 1 ; 																													\
	fi
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "apply" "-auto-approve"

build: apply

# Broken for now, needs IP selector over EIP or PUBIP
#
# ssh: require-tf
# 	ssh 																																\
# 	 -i ./ec2-key 																											\
# 	 -l ubuntu 																													\
# 	 `terraform output -json |jq -r ".ip.value"`


plan-destroy: require-tf
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "plan" "-destroy"

destroy: require-tf
	aws-vault exec $(TF_VAR_aws_profile) --assume-role-ttl=60m -- "/usr/local/bin/terraform" "destroy"

clean: destroy
	rm -rf *.ovpn ec2-key* .terraform terraform.*

reprovision: require-tf require-jq
	ansible-playbook 																									\
	 -v		 																														\
	 -i `terraform output -json |jq -r '. |map(.value) |join (",")'`, \
	 ./ansible/openvpn.yml
