# Exercise a Cloudfalre Waiting Room

## Purpose
This script is used to send requests to a Cloudflare Waiting room. It does this in two phases. The first phase creates a load that is set by the -n, and -s options. The -s option sets the time peroid to sleep between requests. Fractional seconds can be provided (e.g. ".1"). The -n option sets the number of seconds to send requests. The second phase always sends requests at 1 per second, for the number of seconds specified with the -m option.<br>
<br>
The script has two outputs. One is to standard out, where it provide information about the load it about to put on the end point, then emits one of the following characters depending on the results of sending the request:<br>
? - Means that the curl command did not return the HTTP status code. Typically this means the command itself failed.<br>
o - Means that the curl command did not receive a 200 HTTP status code.<br>
. - Means the request went straight to the origin server.<br>
a-zA-Z1-0 - Means the request waited the specified number of seconds, where a=10 seconds, b=20 seconds, c=30 seconds, etc.<br>
! - Means it waited more than 26+26+10=62*10=620 seconds (i.e. ran out of single characters to repersent the wait time.)<br>
<br>
The second output is a file named "results". It contains the following information for each requests:<br>
JobID,Status,Wait_Time,wr_cnt_before,wr_cnt_after,start_time,end_time<br>
<br>
 Where:<br>
     JobID - is a fixed string followed by a sequence number<br>
     Status - is 0 if everything went okay. 1 if there was HTTP status code, and 2 if the status code wasn't 200.<br>
     Wait_Time - is the number of seconds the request was in the waiting room.<br>
     wr_cnt_before - is the number of requests that are currently looping, waiting to make it to the origin, when this request started.<br>
     wr_cnt_after - is the number of requests that are currently looping, waiting to make it to the origin, when this request made it to the origin.<br>
     start_time - is the time, in UNIX epoch format, when the request started.<br>
     end_time - is the time, in UNIX epoch format, when the request finished.<br>
<br>
### How to Run
```
Usage: simulate_requests -n <num_secs_p1> -m <num_secs_p2> -s <sleep_time_p1> -o <results> URL
  Where:
    num_secs_p1 - is the number of seconds to send requests during phase 1.
    num_secs_p2 - is the number of seconds to send requests during phase 2, which is fixed at 1 RPS.
    sleep_time - is the amount of time to sleep between requests. Fractional time accepted (e.g. .3).
    results - is the file to store the per request statistics.

Here is how sleep_time equates to RPS:
        .05 = 20   rps or 1200 rpm
        .1  = 10   rps or 600 rpm
        .2  =  5   rps or 300 rpm
        .3  =  3.3 rps or 200 rpm
        1   =  1   rps or 60 rpm
```
### Exmaple run
```
simulate_requests -s .1 -n 60 -m 60 -o results https://lonestar.org./tickets/1234/
Sending 600 requests to https://lonestar.org./tickets/1234/ at a rate of 10.00 per second. Or 600 per minute.

Wed 10 Mar 2021 10:48:59 AM CST
...................................................................................................................a.aa.aa.a..
Wed 10 Mar 2021 10:50:00 AM CST

Now doing 1 request per second for 60 seconds.
babdacdbeacbc.abbedcbacbddaccdaeebbcabedccaebddbcacedb.cadcedbacabcbeacbbabdcdbaaebddcbcabeeadbcbacadedabbaacd.dabecbabbdecbdaegehgjkfjifggfihjhghhfhifkfj.gjighhgfiihgdihkffiejgjjigggjkijkk
Wed 10 Mar 2021 10:51:01 AM CST

Waiting for jobs to finish
hgiibjjjjcjhjgbgiggikihhjcihhhhlkkknmjjmmjnnonokklmmklnmonmlonoompollplommpmmpolpoqmponngoonqjimqmgjmmnkmogmqoiqpoqolmmqonghpppjpiopoopqomkqnnqgnmqnnppopnqrpptqtrrrrpsrqtrusrtsvusvsrrvstttrvsvsvussrtuwtvrtsvtrvsqunrmtrrrsqnqptvsuqturwsvstnmwuwtusvsvwsouspqtuuvsvrvwtwssvqtuuuwspvoxyzyyvwvzwxyxyyAzyyzABxBBzyxyxxBBACzzyxAvwsyzxztzvuvtCACyvxstuutvCw
Wed 10 Mar 2021 10:54:22 AM CST

```
