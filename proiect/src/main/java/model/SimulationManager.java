package model;


import view.*;

import java.util.*;

import java.util.Random;

public class SimulationManager extends Thread {
    private int totalTimeOfSimulation=0;
    private FinalReportView finalReportView;
    private LogEventsView logEventsView;
   // private LogEventsView2 logEventsView2;
    private int totalNoOfCars=0;
    private PhaseQueue firstListOfPhases=new PhaseQueue(2);
    private PhaseQueue secondListOfPhases=new PhaseQueue(3);
    private PhaseQueue thirdListOfPhases=new PhaseQueue(4);
    private PhaseQueue fourthListOfPhases=new PhaseQueue(5);
    private Semaphore sem1and3;
    private Semaphore sem2;
    private Semaphore sem4;
    private Semaphore secondSem1and3;
    private Semaphore secondSem2;
    private Semaphore secondSem4;
    private String logOfEvents="";
    private String logOfEvents2="";
    private DataView dataView;
    private int waitingTime1=0;
    private int waitingTime2=0;
    private int currentTime=0;
    private int currentSecondsOfCarsWaiting=0;
    private SemaphoreView semaphoreView;
    private SemaphoreView2 semaphoreView2;
    private int timeRecordForSecondSemaphore=0;
    private int greenForSecondSemaphore=1;
    private String report1="";
    private String report2="";
    private PhaseQueue phaseQueue=new PhaseQueue(1);
    private ArrayList <Semaphore> semaphores=new ArrayList<>();
    private ArrayList <Semaphore> semaphores2=new ArrayList<>();
    private ArrayList <Phase> phases=new ArrayList<>();
    public void begin() {
        finalReportView=new FinalReportView();
        logEventsView=new LogEventsView();
        dataView = new DataView();
        initializeButtonListeners();
        semaphoreView=new SemaphoreView();
        dataView.setVisible(true);
        sem1and3=new Semaphore(1);
        sem2=new Semaphore(2);
        sem4=new Semaphore(3);
        semaphores.add(sem1and3);
        semaphores.add(sem2);
        semaphores.add(sem4);


       // logEventsView2=new LogEventsView2();
        semaphoreView2=new SemaphoreView2();
        secondSem1and3=new Semaphore(1);
        secondSem2=new Semaphore(2);
        secondSem4=new Semaphore(3);
        semaphores2.add(secondSem1and3);
        semaphores2.add(secondSem2);
        semaphores2.add(secondSem4);

      //  semaphoreView.setVisible(true);
       // logEventsView.setVisible(true);
       // start();

    }
    public void run()
    {
        semaphoreView.setVisible(true);
        logEventsView.setVisible(true);
        semaphoreView2.setVisible(true);

        semaphoreView2.setGreenToSemaphore1and3();

        while(totalTimeOfSimulation>0)
        {
            //we skip the first element since it is a phase that is green and letting cars move through
            for(Phase phaseAux:phaseQueue.getQueue().subList(1,phaseQueue.getSize()))
            {
                phaseAux.increaseSecondsPassed();
                waitingTime1+=phaseAux.getNoOfCarsWaiting();

            }
            for(Phase phaseAux:firstListOfPhases.getQueue())//.subList(1,firstListOfPhases.getSize()))
            {
                phaseAux.increaseSecondsPassed();
                waitingTime2+=phaseAux.getNoOfCarsWaiting();

            }
            for(Phase phaseAux:secondListOfPhases.getQueue())//.subList(1,secondListOfPhases.getSize()))
            {
                phaseAux.increaseSecondsPassed();
                waitingTime2+=phaseAux.getNoOfCarsWaiting();

            }
            for(Phase phaseAux:thirdListOfPhases.getQueue())//.subList(1,thirdListOfPhases.getSize()))
            {
                phaseAux.increaseSecondsPassed();
                waitingTime2+=phaseAux.getNoOfCarsWaiting();

            }
            for(Phase phaseAux:fourthListOfPhases.getQueue())//.subList(1,fourthListOfPhases.getSize()))
            {
                phaseAux.increaseSecondsPassed();
                waitingTime2+=phaseAux.getNoOfCarsWaiting();

            }
            try {
                sleep(1000);

            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            currentTime++;
            logEventsView.setTime(String.valueOf(currentTime));
            report1+="At time: "+String.valueOf(currentTime)+" total seconds waited by cars is: "+waitingTime1+"\n";
            report2+="At time: "+String.valueOf(currentTime)+" total seconds waited by cars is: "+waitingTime2+"\n";
            //setting the green light for the classic semaphore
            if(timeRecordForSecondSemaphore<=4)
            {
                timeRecordForSecondSemaphore++;

            }
            else {

                timeRecordForSecondSemaphore = 0;
                greenForSecondSemaphore++;
                if(greenForSecondSemaphore==1)
                {
                    semaphoreView2.setGreenToSemaphore1and3();
                    if(firstListOfPhases.getFirstElement().getNoOfCars()>1)
                    {
                        firstListOfPhases.getFirstElement().decreaseNoOfCars();

                    }
                    else
                        firstListOfPhases.removeFirstPhase();
                    if(thirdListOfPhases.getFirstElement().getNoOfCars()>1)
                    {
                        thirdListOfPhases.getFirstElement().decreaseNoOfCars();

                    }
                    else
                        thirdListOfPhases.removeFirstPhase();
                }
                else if(greenForSecondSemaphore==2) {
                    semaphoreView2.setGreenToSemaphore2();
                    if(secondListOfPhases.getFirstElement().getNoOfCars()>1)
                    {
                        secondListOfPhases.getFirstElement().decreaseNoOfCars();

                    }
                    else
                        secondListOfPhases.removeFirstPhase();
                }
                else
                {
                    semaphoreView2.setGreenToSemaphore4();
                    greenForSecondSemaphore=0;
                    if(fourthListOfPhases.getFirstElement().getNoOfCars()>1)
                    {
                        fourthListOfPhases.getFirstElement().decreaseNoOfCars();

                    }
                    else
                        fourthListOfPhases.removeFirstPhase();
                }
            }

            int time=phaseQueue.getFirstElement().getNoOfCars()-1;

            if(phaseQueue.getFirstElement().getSemaphore()==sem1and3)
                    semaphoreView.setGreenToSemaphore1and3();
            else
                if(phaseQueue.getFirstElement().getSemaphore()==sem2)
                    semaphoreView.setGreenToSemaphore2();
                else
                    semaphoreView.setGreenToSemaphore4();
            logOfEvents+= "Id of phase is "+phaseQueue.getFirstElement().getId()+", time gap is "+phaseQueue.getFirstElement().getTimeGap()+", no of cars "+time +"\n";

           // System.out.println("time gap of the phase in process "+phaseQueue.getFirstElement().getTimeGap()+" no of cars is "+time);
            if(phaseQueue.getFirstElement().getNoOfCars()>1)
            {
                phaseQueue.getFirstElement().decreaseNoOfCars();
                //semaphores 1 and 3 turn green in the same time
                if(phaseQueue.getFirstElement().getId()==1 || phaseQueue.getFirstElement().getId()==2 || phaseQueue.getFirstElement().getId()==3) {
                    boolean decreased=phaseQueue.decreaseNoOfCarsFromSem3();
                    if(decreased==true)
                    totalTimeOfSimulation--;
                }
                if(phaseQueue.getFirstElement().getId()==7 || phaseQueue.getFirstElement().getId()==8 || phaseQueue.getFirstElement().getId()==9) {
                    boolean decreased=phaseQueue.decreaseNoOfCarsFromSem1();
                    if(decreased==true)
                    totalTimeOfSimulation--;
                }
            }
            else
                phaseQueue.removeFirstPhase();
            finalReportView.setConclusionFirstSemaphore("In conclusion, out of " + String.valueOf(totalNoOfCars)+ " cars, on average, a car waited for "+String.valueOf(waitingTime1/totalNoOfCars)+" sec");
            finalReportView.setConclusionSecondSemaphore("In conclusion, out of " + String.valueOf(totalNoOfCars)+ " cars, on average, a car waited for "+String.valueOf(waitingTime2/totalNoOfCars)+" sec");
            logEventsView.setLogEvents(logOfEvents);
            totalTimeOfSimulation--;
            System.out.println(totalTimeOfSimulation);
        }
        finalReportView.setReportFirstSemaphore(report1);
        finalReportView.setReportSecondSemaphore(report2);


    }
    public void initializeButtonListeners()
    {
        dataView.addReportButtonListener(e->
        {
            finalReportView.setVisible(true);
        });
        dataView.addStartButtonListener( e1->
        {
            int firstPhaseTimeGap=Integer.valueOf(dataView.getFirstLaneGap1());
            int firstNoOfCars=Integer.valueOf(dataView.getFirstNoOfCars1());
            totalNoOfCars+=firstNoOfCars;
            Phase phase=new Phase(1,sem1and3,firstPhaseTimeGap,firstNoOfCars);
            Phase phase2=new Phase(1,sem1and3,firstPhaseTimeGap,firstNoOfCars);
            phaseQueue.addPhase(phase);
            firstListOfPhases.addPhase(phase2);
            int secondPhaseTimeGap=Integer.valueOf(dataView.getFirstLaneGap2());
            int secondNoOfCars=Integer.valueOf(dataView.getFirstNoOfCars2());
            totalNoOfCars+=secondNoOfCars;
            phase=new Phase(2,sem1and3,secondPhaseTimeGap,secondNoOfCars);
            phase2=new Phase(2,sem1and3,secondPhaseTimeGap,secondNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phaseQueue.addPhase(phase);
            firstListOfPhases.addPhase(phase2);
            phase=new Phase(3,sem1and3,Integer.valueOf(dataView.getFirstLaneGap3()),Integer.valueOf(dataView.getFirstNoOfCars3()));
            phase2=new Phase(3,sem1and3,Integer.valueOf(dataView.getFirstLaneGap3()),Integer.valueOf(dataView.getFirstNoOfCars3()));
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phaseQueue.addPhase(phase);
            firstListOfPhases.addPhase(phase2);
            totalNoOfCars+=Integer.valueOf(dataView.getFirstNoOfCars3());

            firstPhaseTimeGap=Integer.valueOf(dataView.getSecondLaneGap1());
            firstNoOfCars=Integer.valueOf(dataView.getSecondNoOfCars1());
            totalNoOfCars+=firstNoOfCars;
            phase=new Phase(4,sem2,firstPhaseTimeGap,firstNoOfCars);
            phase2=new Phase(4,sem2,firstPhaseTimeGap,firstNoOfCars);
            phaseQueue.addPhase(phase);
            secondListOfPhases.addPhase(phase2);
            secondPhaseTimeGap=Integer.valueOf(dataView.getSecondLaneGap2());
            secondNoOfCars=Integer.valueOf(dataView.getSecondNoOfCars2());
            totalNoOfCars+=secondNoOfCars;
            phase=new Phase(5,sem2,secondPhaseTimeGap,secondNoOfCars);
            phase2=new Phase(5,sem2,secondPhaseTimeGap,secondNoOfCars);
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phaseQueue.addPhase(phase);
            secondListOfPhases.addPhase(phase2);
            phase=new Phase(6,sem2,Integer.valueOf(dataView.getSecondLaneGap3()),Integer.valueOf(dataView.getSecondNoOfCars3()));
            phase=new Phase(6,sem2,Integer.valueOf(dataView.getSecondLaneGap3()),Integer.valueOf(dataView.getSecondNoOfCars3()));
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phaseQueue.addPhase(phase);
            secondListOfPhases.addPhase(phase2);
            totalNoOfCars+=Integer.valueOf(dataView.getSecondNoOfCars3());


            firstPhaseTimeGap=Integer.valueOf(dataView.getThirdLaneGap1());
            firstNoOfCars=Integer.valueOf(dataView.getThirdNoOfCars1());
            totalNoOfCars+=firstNoOfCars;
            phase=new Phase(7,sem1and3,firstPhaseTimeGap,firstNoOfCars);
            phase2=new Phase(7,sem1and3,firstPhaseTimeGap,firstNoOfCars);
            phaseQueue.addPhase(phase);
            thirdListOfPhases.addPhase(phase2);
            secondPhaseTimeGap=Integer.valueOf(dataView.getThirdLaneGap2());
            secondNoOfCars=Integer.valueOf(dataView.getThirdNoOfCars2());
            totalNoOfCars+=secondNoOfCars;
            phase=new Phase(8,sem1and3,secondPhaseTimeGap,secondNoOfCars);
            phase2=new Phase(8,sem1and3,secondPhaseTimeGap,secondNoOfCars);
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phaseQueue.addPhase(phase);
            thirdListOfPhases.addPhase(phase2);
            phase=new Phase(9,sem1and3,Integer.valueOf(dataView.getThirdLaneGap3()),Integer.valueOf(dataView.getThirdNoOfCars3()));
            phase2=new Phase(9,sem1and3,Integer.valueOf(dataView.getThirdLaneGap3()),Integer.valueOf(dataView.getThirdNoOfCars3()));
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phaseQueue.addPhase(phase);
            thirdListOfPhases.addPhase(phase2);
            totalNoOfCars+=Integer.valueOf(dataView.getThirdNoOfCars3());

            firstPhaseTimeGap=Integer.valueOf(dataView.getFourthLaneGap1());
            firstNoOfCars=Integer.valueOf(dataView.getFourthNoOfCars1());
            totalNoOfCars+=firstNoOfCars;
            phase=new Phase(10,sem4,firstPhaseTimeGap,firstNoOfCars);
            phase2=new Phase(10,sem4,firstPhaseTimeGap,firstNoOfCars);
            phaseQueue.addPhase(phase);
            fourthListOfPhases.addPhase(phase2);
            secondPhaseTimeGap=Integer.valueOf(dataView.getFourthLaneGap2());
            secondNoOfCars=Integer.valueOf(dataView.getFourthNoOfCars2());
            totalNoOfCars+=secondNoOfCars;
            phase=new Phase(11,sem4,secondPhaseTimeGap,secondNoOfCars);
            phase2=new Phase(11,sem4,secondPhaseTimeGap,secondNoOfCars);
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars);
            phaseQueue.addPhase(phase);
            fourthListOfPhases.addPhase(phase2);
            phase=new Phase(12,sem4,Integer.valueOf(dataView.getFourthLaneGap3()),Integer.valueOf(dataView.getFourthNoOfCars3()));
            phase2=new Phase(12,sem4,Integer.valueOf(dataView.getFourthLaneGap3()),Integer.valueOf(dataView.getFourthNoOfCars3()));
            phase.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phase2.setSecondsPaused(firstPhaseTimeGap*firstNoOfCars+secondPhaseTimeGap*secondNoOfCars);
            phaseQueue.addPhase(phase);
            fourthListOfPhases.addPhase(phase2);
            totalNoOfCars+=Integer.valueOf(dataView.getFourthNoOfCars3());

            phaseQueue.sort();

            for(Phase phaseAux:phaseQueue.getQueue())
            {
                System.out.println("id is: " + phaseAux.getId()+ " and time gap is: "+phaseAux.getTimeGap());
                //we consider time for a car to exit the lane in 1 second
                totalTimeOfSimulation+=phaseAux.getNoOfCars();
            }
            start();
        });


    }


}


