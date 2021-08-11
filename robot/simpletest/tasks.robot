*** Settings ***
Documentation   Template robot main suite.

*** Variables ***
${VAR1}=  Value of var1 from script!
${VAR2}=  Value of var2 from script!

*** Tasks ***
Minimal task
    Log to Console  "  "
    Log To console  VAR1=${VAR1}
    Log To console  VAR2=${VAR2}
