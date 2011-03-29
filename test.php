<?php

$fails = 0;

function vaeql_test($q, $a, $path = false) {
  global $passes, $fails;
  $r = _vaeql_query($q);
  if (($a === false && $r != null) || ($r[1] != $a || $r[0] != $path)) {
    echo "FAIL: $q\n";
    echo " expected " . ($path ? "path" : "val ") . ": $a\n";
    echo " got      " . ($r[0] ? "path" : "val ") . ": " . $r[1] . "\n";
    $fails++;
  } else {
    $passes++;
  }
}

if (!function_exists('_vae_fetch')) {
  function _vae_fetch($path, $ctxt) {
    return $path . "_val";
  }
  
  function _vaeql_function($function, $args) {
    if (!function_exists($function)) return "[FUNCTION NOT FOUND]";
    return call_user_func_array($function, $args);
  }

  function _vaeql_path($path) {
    global $_VAE;
    return _vae_fetch($path, $_VAE['vaeql_context']);
  }

  function _vaeql_query($query, $context = null) {
    global $_VAE;
    $_VAE['vaeql_context'] = $context;
    return _vaeql_query_internal($query);
  }

  function _vaeql_variable($name) {
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

vaeql_test('1', '1');
vaeql_test('1+2', '3');
vaeql_test('1+2*3', '7');
vaeql_test('(1+2)*3', '9');
vaeql_test('(7*11)+14', '91');
vaeql_test('(((5+6)//3*5+(6//7)))', '19.1904');
vaeql_test('artists', 'artists', true);
//vaeql_test('artists[', false);
vaeql_test('/artists', '/artists', true);
vaeql_test('@artists', '@artists', true);
vaeql_test('@artists/albums', '@artists/albums', true);
vaeql_test('@/artists/albums', '@/artists/albums', true);
vaeql_test('artists/123/albums', 'artists/123/albums', true);
vaeql_test('/artists/123/albums', '/artists/123/albums', true);
vaeql_test('123/albums', '123/albums', true);
$_REQUEST['id'] = 301;
$_REQUEST['ssl'] = "sec";
vaeql_test('artists/$id', 'artists/301', true);
vaeql_test('123/albums/curalbum()/name', '123/albums/201/name', true);
vaeql_test('123/albums/curalbum($id)/name', '123/albums/203/name', true);
vaeql_test('123/albums/curalbum(1)/name', '123/albums/204/name', true);
vaeql_test('123/albums/curalbum(path)/name', '123/albums/205/name', true);
vaeql_test('123/albums/curalbum(path, $id)/name', '123/albums/206/name', true);
vaeql_test('loggedin()', '211');
vaeql_test('loggedin(/home/allow_ssl)', '212');
vaeql_test('loggedin($ssl)', '213');
vaeql_test('(1 ? "yes" : "no")', 'yes');
vaeql_test('(0 ? "no" : "yes")', 'yes');
vaeql_test('($kevin ? path1 : path2)', 'path1', true);

echo "$passes passes, $fails fails\n";

?>