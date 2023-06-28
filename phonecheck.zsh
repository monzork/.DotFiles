# Phonecheck vars
export CYPRESS_CYPRESS=""
export STRIPE="sk_test_51IIyuJIEuTex3tLOBQvfBRSCBAM4Xgu8lffbzZS0oQrWOOzXD1UF7rSJtH7kQdN92YrQDMMo2Wn7tWqKvJE26a1W00UtnNUQZS"
export CYPRESS_STRIPE="sk_test_51IIyuJIEuTex3tLOBQvfBRSCBAM4Xgu8lffbzZS0oQrWOOzXD1UF7rSJtH7kQdN92YrQDMMo2Wn7tWqKvJE26a1W00UtnNUQZS"
export CYPRESS_SATURNKEY="PII-A3Z-OPN-AGP-RJ3-AJ4-TT6-5B1"


alias common-libraries-update='rm package-lock.json; rm -rf node_modules/common-libraries; npm i'
alias pc-eu-prod-tunnel='ssh -g -N -L 3304:phonecheck-prod-aurora-cluster.cluster-cg30qgkkaxpu.eu-west-1.rds.amazonaws.com:3306 -i ~/.ssh/id_rsa ec2-user@ec2-34-245-91-44.eu-west-1.compute.amazonaws.com'
alias pc-eu-prod-util-tunnel='ssh -g -N -L 3304:phonecheck-prod-aurora-cluster-clone-cluster-new-cluster.cluster-cg30qgkkaxpu.eu-west-1.rds.amazonaws.com:3306 -i ~/.ssh/id_rsa ec2-user@ec2-34-245-91-44.eu-west-1.compute.amazonaws.com'
alias pc-backup-db-tunnel='ssh -g -N -L 3305:cluster-phonecheckauroradb.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-db-tunnel='ssh -g -N -L 3307:dev-phonecheckauroradb.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-prod-db-tunnel='ssh -g -N -L 3308:cluster-phonecheckauroradb.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-prod-sy-db-tunnel='ssh -g -N -L 3311:core-production-aurora3-cluster.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-stage-db-tunnel='ssh -g -N -L 3310:stg-phonecheckauroradb-cluster.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-stage-sy-db-tunnel='ssh -g -N -L 3309:core-staging-cluster.cluster-cewdwgf3cuah.us-west-1.rds.amazonaws.com:3306 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias pc-redis-write-tunnel='ssh -g -N -L 6379:core-stg.rntfmn.ng.0001.usw1.cache.amazonaws.com:6379 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com ulimit -n 4096'
alias pc-redis-read-tunnel='ssh -g -N -L 6380:core-stg.rntfmn.ng.0001.usw1.cache.amazonaws.com:6380 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com ulimit -n 4096'
alias pc-proxy-tunnel='ssh -g -N -L 3001:ec2-184-72-30-11.us-west-1.compute.amazonaws.com:3000 -i ~/.ssh/bastion-staging.pem ec2-user@bastion.stg.phonecheck.com'
alias core-pull-all='find . -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && git checkout package-lock.json && git pull && rm -f package-lock.json && npm i" \;'
alias pc-stage-connect='ssh phonecheckui@node.stg.phonecheck.com'
alias pc-dev-connect='ssh phonecheckui@54.177.147.143'
alias pm2-flush-all='rm -rf ~/.pm2/logs/*'
alias pm2-start-all='pm2 delete all; pm2-flush-all; pm2 start ~/code/phonecheck/core/pm2.config.js; pm2 logs'

