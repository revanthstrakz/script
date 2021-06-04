for i in *
do 
    git add $i 
    git commit -m "added $i"
    git push
done

