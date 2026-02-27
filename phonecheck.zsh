export NPM_TOKEN="encrypted_pat_phonecheck"

alias pc-eu-prod-util-tunnel='ssh -g -N -L 3304:phonecheck-prod-aurora-cluster-clone-prod-rw.cluster-custom-cg30qgkkaxpu.eu-west-1.rds.amazonaws.com:3306 -i ~/.ssh/id_rsa ec2-user@ec2-54-228-74-67.eu-west-1.compute.amazonaws.com'
alias pc-prod-sy-db-tunnel='ssh -g -N -L 3311:core-production-aurora3-cluster.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-stage-sy-db-tunnel='ssh -g -N -L 3309:core-staging-cluster.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-proxy-tunnel='ssh -g -N -L 3001:ec2-184-72-30-11.us-west-1.compute.amazonaws.com:3000 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pm2-start-all='pm2 delete all; pm2-flush-all; pm2 start ~/code/phonecheck/core/pm2.config.js; pm2 logs'
