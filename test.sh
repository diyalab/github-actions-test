# tag=qa_20220614
tag1=qa_20220614_RC3
release_branch=release-20220614
release_date="$(cut -d'-' -f2 <<<"$release_branch")"
search_word=qa_$release_date
git for-each-ref --sort=creatordate --format '%(refname) %(creatordate)' refs/tags | grep $search_word > tags.txt
latest_tag=`tail -1 tags.txt | xargs `
echo $latest_tag
tag_ref="$(cut -d' ' -f1 <<<"$latest_tag")"
tag="$(cut -d'/' -f3 <<<"$tag_ref")"
echo $tag
echo $tag_ref
echo $release_date
echo $search_word
count=`echo $tag | grep -o "_" | wc -l`
# echo $count
if [ $count == 1 ]
then
    echo "old tag is $tag"
    new_tag=$tag"_"RC1
    echo "new tag is $new_tag"
else 
    if [ $count == 2 ]
    then
        f1="$(cut -d'_' -f1 <<<"$tag1")"
        f2="$(cut -d'_' -f2 <<<"$tag1")"
        f3="$(cut -d'_' -f3 <<<"$tag1")"
        rc_number=`echo $f3 | grep -Eo '[0-9]+$'`
        echo $rc_number
        rc_number_new=$((rc_number+1))
        echo $rc_number_new
        new_tag=$f1"_"$f2"_"RC$rc_number_new
        echo $new_tag
    fi
fi
