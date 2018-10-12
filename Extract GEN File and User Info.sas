
/*Program provides dates and times of creation and when it was reviewed by SAS*/

   /*  /t:c  -  indicates you want a time field 'T', of type creation 'C'      */
   /*  /a:-d - return information for files only, not directories                 */

                                                                                                               
/*%let file=B:\LR\Genasys\4MIC3K\Genasys_Output\Rq10900_4MIC3K_Initial_PE.prn;                                                                                                      */


%let user=%sysget(username);
%let QCdate=%sysfunc(today());  %let QCdate=%sysfunc(putn(&QCdate,weekdate29.));
%let QCtime=%sysfunc(time(),time.);

filename foo pipe "dir &GENin /t:w  /a:-d ";   

data QCRun;
length Description $200. Value $200.;
Description="The current QC run was scheduled by &user. on the following date and time:";
Value="&QCdate. at &QCtime.";
run;
                                                                                            

data GENRun;                                                                                                                            
	infile foo firstobs=6;   

  /* The ?? format modifier for error reporting suppresses printing the messages */
  /* and the input lines when SAS encounters invalid data values. The automatic  */
  /* variable _ERROR_ is not set to 1 for the invalid observation.               */
  /* The & format modifier enables you to read character values that contain     */
  /* embedded blanks with list input and to specify a character informat.  SAS   */
  /* reads until it encounters multiple blanks.                                  */
 
  input fl_date ?? :mmddyy8. fl_time ?? & time8.;                                                                                        

  if fl_date eq . then stop;                                                                                                            

  put fl_date= worddate. / fl_time= timeampm.;                                                                                          

GENdate=put(fl_date,weekdate29.);
GENtime=put(fl_time,time8.);

length Description $200. Value $200.;
Description="The GENASYS request .prn file being QC'ed was last modified on:";
Value=GENdate||" at "||GENtime;

drop fl_date fl_time GENdate GENtime;
run;
