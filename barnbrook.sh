# filter and count number of terms in ontology (.obo file)
echo "Version:" > barnbrook.go.statistics.txt
head -2 go.obo >> barnbrook.go.statistics.txt 
egrep '^name:' go.obo > go.obo.names.including.obsoletes.txt
echo "go.obo.names.including.obsoletes.txt" >> barnbrook.go.statistics.txt
wc -l go.obo.names.including.obsoletes.txt >> barnbrook.go.statistics.txt
egrep -v 'obsolete' go.obo.names.including.obsoletes.txt > go.obo.names.txt
echo "Without obsoletes:" >> barnbrook.go.statistics.txt
wc -l go.obo.names.txt >> barnbrook.go.statistics.txt
# filter square brackets []
egrep -v '\[' go.obo.names.txt > go.obo.no.brackets.txt
# count number of remaining terms
echo "Without brackets:" >> barnbrook.go.statistics.txt
wc -l go.obo.no.brackets.txt >> barnbrook.go.statistics.txt
# filter parentheses ()
egrep -v '\(' go.obo.no.brackets.txt > go.obo.no.brackets.no.parentheses.txt
# count number of remaining terms
echo "Without brackets or parentheses:" >> barnbrook.go.statistics.txt
wc -l go.obo.no.brackets.no.parentheses.txt >> barnbrook.go.statistics.txt
echo "Verify expected number of outputs:" >> barnbrook.go.statistics.txt
egrep '^name:' go.obo | egrep -v 'obsolete' | egrep -v '\[' | egrep -v '\(' | wc -l >> barnbrook.go.statistics.txt

# find the strings that you're looking for
./barnbrook.pl