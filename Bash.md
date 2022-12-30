# YesNo

```bash
read -p "Do you want to proceed? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac
```

# Yes 

```bash
read -p "Do you want to proceed? (y/N) " yn

if [[ $yn =~ [yY](es)* ]]
then
   echo proceed
fi
```