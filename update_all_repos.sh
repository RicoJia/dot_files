for repo in $(ls)
do
    if [[ -d $repo ]]
    then
        cd $repo
        git pull origin master
        cd ..
    fi
done
