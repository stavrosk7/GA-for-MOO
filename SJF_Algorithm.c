//Program for Shortest Job First (SJF) Scheduling Algorithm_
#include&lt;stdio.h&gt;
 
int main()
{
    int n,bt[20],wt[20],tat[20],avwt=0,avtat=0,i,j;
    printf("Enter total number of processes(maximum 20):");
    scanf("%d",&amp;n);
 
    printf("nEnter Process Burst Timen");
    for(i=0;i&lt;n;i++)
    {
        printf("P[%d]:",i+1);
        scanf("%d",&amp;bt[i]);
    }
 
    wt[0]=0;    //waiting time for first process is 0
 
    //calculating waiting time
    for(i=1;i&lt;n;i++)
    {
        wt[i]=0;
        for(j=0;j&lt;i;j++)
            wt[i]+=bt[j];
    }
 
    printf("nProcessttBurst TimetWaiting TimetTurnaround Time");
 
    //calculating turnaround time
    for(i=0;i&lt;n;i++)
    {
        tat[i]=bt[i]+wt[i];
        avwt+=wt[i];
        avtat+=tat[i];
        printf("nP[%d]tt%dtt%dtt%d",i+1,bt[i],wt[i],tat[i]);
    }
 
    avwt/=i;
    avtat/=i;
    printf("nnAverage Waiting Time:%d",avwt);
    printf("nAverage Turnaround Time:%d",avtat);
 
    return 0;
}
