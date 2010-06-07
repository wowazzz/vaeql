<?php

require_once("VerbQueryLanguage.php");

class VerbQueryLanguageWithVerbData extends VerbQueryLanguage {
  function resolvePath($input) {
    return "resolved, beyatch";
  }
}

$__vql = new VerbQueryLanguageWithVerbData();
echo $__vql->query("kevin[k='1']");

?>