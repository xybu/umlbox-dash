#!/usr/bin/python

import os
import sys
import subprocess

correct_stdout = 0
correct_stderr = 0
total_test = 20

def test():
	global correct_stdout
	global correct_stderr
	
	subp = subprocess.Popen(['umlbox', '-B', '-fw', '.', '-m', '64M', './hello'], 
		bufsize = 0, stdin = subprocess.PIPE, 
		stdout = subprocess.PIPE, stderr = subprocess.PIPE)

	oe = subp.communicate(None)
	
	print '*' * 50
	print "exit code:"
	print subp.wait()
	print "stdout:"
	print oe[0]
	print "stderr:"
	print oe[1]
	
	if oe[0] == 'Hello world!': correct_stdout += 1
	if oe[1] == 'This is stderr!\n': correct_stderr += 1

for i in range(total_test):
	test()

print "Correct stdout: {0} / {1}".format(correct_stdout, total_test)
print "Correct stderr: {0} / {1}".format(correct_stderr, total_test)
