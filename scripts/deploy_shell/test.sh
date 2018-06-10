#!/usr/bin/expect

set timeout 10
set PATH [lindex $argv 0]
set ENV [lindex $argv 1]

spawn /usr/bin/php $PATH

if { expect "Yii Application*" }{
   puts "test" }
