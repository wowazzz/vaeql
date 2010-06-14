<?php

$fails = 0;

function verbql_test($q, $a, $path = false) {
  global $passes, $fails;
  $r = _verbql_query($q);
  if ($r[1] != $a || $r[0] != $path) {
    echo "FAIL: $q\n";
    echo " expected " . ($path ? "path" : "val ") . ": $a\n";
    echo " got      " . ($r[0] ? "path" : "val ") . ": " . $r[1] . "\n";
    $fails++;
  } else {
    $passes++;
  }
}

verbql_test('1', '1');
verbql_test('1+2', '3');
verbql_test('1+2*3', '7');
verbql_test('(1+2)*3', '9');
verbql_test('(7*11)+14', '91');
verbql_test('(((5+6)//3*5+(6//7)))', '19.1904');
verbql_test('artists', 'artists', true);
//verbql_test('/artists
//verbql_test('@artists
//verbql_test('@artists/albums
//verbql_test('@/artists/albums
//verbql_test('artists/123/albums
//verbql_test('/artists/123/albums
//verbql_test('123/albums
//verbql_test('123/albums/curalbum()/name
//verbql_test('123/albums/curalbum($id)/name
//verbql_test('123/albums/curalbum(1)/name
//verbql_test('123/albums/curalbum(path)/name
//verbql_test('123/albums/curalbum(path, $id)/name
//verbql_test('loggedin()
//verbql_test('loggedin(/home/allow_ssl)
//verbql_test('loggedin($ssl)
//verbql_test('(1 ? "yes" : "no")
//verbql_test('(0 ? "no" : "yes")
//verbql_test('($kevin ? path1 : path2)

echo "$passes passes, $fails fails\n";

?>