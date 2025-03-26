#!/bin/bash
source_filename="access.log"
filename="report.txt"
counter=0

while read -r line; do
    let counter+=1
done < $source_filename

echo "Отчёт о логе веб-сервера" > $filename
echo "========================" >> $filename
echo "Общее количество запросов:        $counter" >> $filename

cat $source_filename | \
awk '{ addresses[$1] } END { print "Количество уникальных IP-адресов:         ", length(addresses) }' >> $filename

cat $source_filename | \
awk '{
    if (match($0, /"([A-Z]+) /, m))
        methods[m[1]]++
} END {
    print ""
    print "Количество запросов по методам:"
    for (i in methods)
        print " * ", i, methods[i]
}' >> $filename

echo "" >> $filename

cat $source_filename | \
awk '{
    if (match($0, /"[A-Z]+ ([^ ]+)/, mm))
        urls[mm[1]]++
} END {
    max = 0
    for (url in urls) {
        if (urls[url] > max) {
            max = urls[url]
            popular = url
        }
    }
    print "Самый популярный URL:        ", max, popular
}' >> $filename

echo "Отчёт сохранён в файл $filename"
