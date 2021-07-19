$l=0
for i in *
do 
    git add $i 
    git commit -m "added $i"
    $l=$l+1
    if $l==5; then
        git push
        $l=0
    fi
        
done

