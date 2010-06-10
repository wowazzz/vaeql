<?php

require_once("VerbQueryLanguage.php");

class VerbQueryLanguageWithVerbData extends VerbQueryLanguage {
  function resolvePath($input) {
    return "resolved, beyatch";
  }
}

$__vql = new VerbQueryLanguageWithVerbData();


echo $__vql->query("100==200") . "\n";
//echo $__vql->query("~posts") . "\n";
//echo $__vql->query("!path") . "\n";
//echo $__vql->query("path") . "\n";
//echo $__vql->query("fn()") . "\n";
//echo $__vql->query("'single quote str'") . "\n";
//echo $__vql->query("\$variable") . "\n";
//echo $__vql->query("100") . "\n";
//echo $__vql->query("100.12") . "\n";
//echo $__vql->query("kevin[") . "\n";

?>