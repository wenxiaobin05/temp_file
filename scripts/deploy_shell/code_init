#!/usr/bin/expect

set timeout 10
set PATH [lindex $argv 0]
set ENV [lindex $argv 1]

spawn /usr/bin/php $PATH
expect {
  "Yii Application" {send "$ENV\r";exp_continue}
  "Initialize" {send "yes\r";exp_continue}
  "Start*" {send "A\r";exp_continue}
  "*SAAS*"{send "$ENV\r"}
}
