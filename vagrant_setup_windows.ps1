cd ..
move vagrant azurelaagent
echo "include azurelaagent" > test.pp
puppet module install puppetlabs-stdlib --target-dir c:\ --ignore-dependencies
puppet module install puppetlabs-powershell --target-dir c:\ --ignore-dependencies