<?php

echo _verbql_query("100==200") . "\n";
echo _verbql_query("~posts") . "\n";
echo _verbql_query("!path") . "\n";
echo _verbql_query("path") . "\n";
echo _verbql_query("fn()") . "\n";
echo _verbql_query("'single quote str'") . "\n";
echo _verbql_query("\$variable") . "\n";
echo _verbql_query("100") . "\n";
echo _verbql_query("100.12") . "\n";
echo _verbql_query("kevin[") . "\n";

?>