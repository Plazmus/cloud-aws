#!/bin/bash

# List certificates by expiration date
# Find which ELB has attached selected certificate
# --------------------------------------------------------
# Created by  : Marcin Wyrembak
# --------------------------------------------------------

confirmSelection() {
    echo "Continue?"
    read -p "[y/N]" CONTINUE
    case ${CONTINUE} in
        Y|y)
            echo "Processing..."
        ;;
        *)
            echo "Canceled"
            exit 1
        ;;
    esac
}
showCerts() {
    aws elb describe-load-balancers --region ${awsregion} --output text  --query "LoadBalancerDescriptions[*].{ID:LoadBalancerName,LIS:ListenerDescriptions[*].Listener}" | grep -B1 "${certName}"
}

checkAndPrepareBatch() {
    echo "Getting list of certs..."
    certs=$(aws iam list-server-certificates --output text --query 'ServerCertificateMetadataList[*].[Expiration,ServerCertificateName]' | sort | sed 's/Z[[:space:]]*/Z__/g')
    echo "Choose cert to Check which ELB has it attached"
    select option in "Quit" ${certs}; do
        if [[ "${option}" = "Quit" ]]; then
            exit 0
        elif [[ -n "${option}" ]]; then
            certName=$(echo ${option} | awk -F__ '{print $2'})
            echo "You selected: ${certName}"
            echo "Select region"
            awsregions=$(aws ec2 describe-regions --query 'Regions[].{Name:RegionName}' --output text)
            select region in "Quit" "All" ${awsregions}; do
                if [[ "${region}" == "Quit" ]]; then
                    exit 0
                elif [[ "${region}" == "All" ]]; then
                    echo "You selected: ${region}"
                    while read -r awsregion; do
                        echo "------------------------------------------------------------------------------------------------"
                        echo "==-- ${awsregion} --=="
                        echo "------------------------------------------------------------------------------------------------"
                        showCerts
                    done <<< "${awsregions}"
                elif [ -n "${region}" ]; then
                    awsregion=${region}
                    echo "You selected: ${awsregion}"
                    showCerts
                fi
            done
        else
            echo "Canceled"
        exit 1
        fi
    done
}

echo "---------------------------------------"
echo "Certificates sorted by expiration date"
echo "---------------------------------------"
checkAndPrepareBatch
