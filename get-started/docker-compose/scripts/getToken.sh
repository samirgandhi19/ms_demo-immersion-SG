token=$(curl --insecure      --data "client_id=clientkey"      --data "client_secret=clientsecret"      --data "scope=oob"      --data "grant_type=password"      --data "username=arose"      --data "password=StRonG5^)" 'https://localhost:8443/auth/oauth/v2/token' |     python -c "import sys, json; print json.load(sys.stdin)['access_token']") && curl --insecure https://localhost/recSvc/v1/users/129/orders?access_token=$token
echo ""
echo ""
echo ""
echo "called https://localhost/recSvc/v1/users/129/orders?access_token=$token"
