<?php

$fails = 0;

function verbql_test($q, $a, $path = false) {
  global $passes, $fails;
  $r = _verbql_query($q);
  if (($a === false && $r != null) || ($r[1] != $a || $r[0] != $path)) {
    echo "FAIL: $q\n";
    echo " expected " . ($path ? "path" : "val ") . ": $a\n";
    echo " got      " . ($r[0] ? "path" : "val ") . ": " . $r[1] . "\n";
    $fails++;
  } else {
    $passes++;
  }
}

if (!function_exists('_verb_fetch')) {
  function _verb_fetch($path, $ctxt) {
    return $path . "_val";
  }
  
  function _verbql_function($function, $args) {
    if (!function_exists($function)) return "[FUNCTION NOT FOUND]";
    return call_user_func_array($function, $args);
  }

  function _verbql_path($path) {
    global $_VERB;
    return _verb_fetch($path, $_VERB['verbql_context']);
  }

  function _verbql_query($query, $context = null) {
    global $_VERB;
    $_VERB['verbql_context'] = $context;
    return _verbql_query_internal($query);
  }

  function _verbql_variable($name) {
    return $_REQUEST[$name];
  }
}

function curalbum($param = null, $id = null) {
  if ($id == 301) return 206;
  if ($param == 301) return 203;
  if ($param == 1) return 204;
  if ($param == "path_val") return 205;
  return 201;
}

function loggedin($val = null) {
  if ($val == "/home/allow_ssl_val") return 212;
  if ($val == "sec") return 213;
  return 211;
}

verbql_test('1', '1');
verbql_test('1+2', '3');
verbql_test('1+2*3', '7');
verbql_test('(1+2)*3', '9');
verbql_test('(7*11)+14', '91');
verbql_test('(((5+6)//3*5+(6//7)))', '19.1904');
verbql_test('artists', 'artists', true);
//verbql_test('artists[', false);
verbql_test('/artists', '/artists', true);
verbql_test('@artists', '@artists', true);
verbql_test('@artists/albums', '@artists/albums', true);
verbql_test('@/artists/albums', '@/artists/albums', true);
verbql_test('artists/123/albums', 'artists/123/albums', true);
verbql_test('/artists/123/albums', '/artists/123/albums', true);
verbql_test('123/albums', '123/albums', true);
$_REQUEST['id'] = 301;
$_REQUEST['ssl'] = "sec";
verbql_test('artists/$id', 'artists/301', true);
verbql_test('123/albums/curalbum()/name', '123/albums/201/name', true);
verbql_test('123/albums/curalbum($id)/name', '123/albums/203/name', true);
verbql_test('123/albums/curalbum(1)/name', '123/albums/204/name', true);
verbql_test('123/albums/curalbum(path)/name', '123/albums/205/name', true);
verbql_test('123/albums/curalbum(path, $id)/name', '123/albums/206/name', true);
verbql_test('loggedin()', '211');
verbql_test('loggedin(/home/allow_ssl)', '212');
verbql_test('loggedin($ssl)', '213');
verbql_test('(1 ? "yes" : "no")', 'yes');
verbql_test('(0 ? "no" : "yes")', 'yes');
verbql_test('($kevin ? path1 : path2)', 'path1', true);

echo "$passes passes, $fails fails\n";

?>