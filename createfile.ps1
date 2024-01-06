$a ='0'
remove-item C:/file -Recurse
md C:/file
cd C:/file
For($i=00;$i -le 9; ++$i) {
new-item $("File$a$i.txt") -value File$a$i
}
For($c=10;$c -le 19; ++$c) {
new-item $("File$c.txt") -value File$c
}