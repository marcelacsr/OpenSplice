/*
 *                         Vortex OpenSplice
 *
 *   This software and documentation are Copyright 2006 to  ADLINK
 *   Technology Limited, its affiliated companies and licensors. All rights
 *   reserved.
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 */

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.omg.dds.core.Duration;
import org.omg.dds.sub.Sample;

/**
 * The Throughput example measures data throughput in bytes per second. The
 * publisher allows you to specify a payload size in bytes as well as allowing
 * you to specify whether to send data in bursts. The publisher will continue to
 * send data forever unless a time out is specified. The subscriber will receive
 * data and output the total amount received and the data rate in bytes per
 * second. It will also indicate if any samples were received out of order. A
 * maximum number of cycles can be specified and once this has been reached the
 * subscriber will terminate and output totals and averages.
 * 
 * This class performs the subscriber role in this example.
 */
class Subscriber_impl {
    private static final int BYTES_PER_SEC_TO_MEGABITS_PER_SEC = 125000;

    /**
     * This function calculates the number of samples received
     *
     * @param count
     *            the map tracking sample count values
     * @param startCount
     *            the map tracking sample count start or previous values
     * @param prevCount
     *            if set to true, count2's value should be set to count1 after
     *            adding to total
     * @return the number of samples received
     */
    long samplesReceived(java.util.Map<Long, Long> count1,
            java.util.Map<Long, Long> count2, boolean prevCount) {
        long total = 0;
        for (java.util.Map.Entry<Long, Long> entry : count1.entrySet()) {
            total += entry.getValue() - count2.get(entry.getKey());

            if (prevCount) {
                count2.put(entry.getKey(), entry.getValue());
            }
        }
        return total;
    }

    /**
     * Performs the subscriber role in this example.
     */
    public void run(String args[]) {
        try {

            /*
             * Get the program parameters Parameters: subscriber [maxCycles]
             * [pollingDelay] [partitionName]
             */
            long maxCycles = 0;
            long pollingDelay = 0;
            String partitionName = "Throughput example";
            if (args.length == 1
                    && (args[0].equals("-h") || args[0].equals("--help"))) {
                Exception usage = new Exception(
                        "Usage (parameters must be supplied in order):\n"
                                + "./subscriber [maxCycles (0 = infinite)] [pollingDelay (ms, 0 = event based)] [partitionName]\n"
                                + "Defaults: \n"
                                + "./subscriber 0 0 \"Throughput example\"");
                throw usage;
            }
            if (args.length > 0) {
                maxCycles = Integer.parseInt(args[0]); // The number of times to
                                                       // output statistics
                                                       // before terminating
            }
            if (args.length > 1) {
                pollingDelay = Integer.parseInt(args[1]); // The number of ms to
                                                          // wait between
                                                          // reads (0 = event
                                                          // based)
            }
            if (args.length > 2) {
                partitionName = args[2]; // The name of the partition
            }
            System.out.println("maxCycles: " + maxCycles + " | pollingDelay: "
                    + pollingDelay + " | partitionName: " + partitionName
                    + "\n");

            /* Initialize entities */
            final SubEntities e = new SubEntities("Throughput example");

            Runtime.getRuntime().addShutdownHook(new Thread() {
                public void run() {
                    e.terminated.setTriggerValue(true);
                }
            });

            java.util.Map<Long, Long> count = new java.util.HashMap<Long, Long>();
            java.util.Map<Long, Long> startCount = new java.util.HashMap<Long, Long>();
            java.util.Map<Long, Long> prevCount = new java.util.HashMap<Long, Long>();
            long outOfOrder = 0;
            long received = 0;
            long prevReceived = 0;
            long time = 0;
            long startTime = 0;
            long prevTime = 0;

            Duration waitTimeout = e.env.getSPI().infiniteDuration();

            List<Sample<ThroughputModule.DataType>> samples = new ArrayList<Sample<ThroughputModule.DataType>>(
                    400);

            long payloadSize = 0;

            System.out.println("Waiting for samples...");

            /* Loop through until the maxCycles has been reached (0 = infinite) */
            long cycles = 0;
            while (!e.terminated.getTriggerValue()
                    && (maxCycles == 0 || cycles < maxCycles)) {
                /* If polling delay is set */
                if (pollingDelay > 0) {
                    /* Sleep before polling again */
                    Thread.sleep(pollingDelay);
                } else {
                    /* Wait for samples */
                    e.waitSet.waitForConditions(waitTimeout);
                }

                /* Take sample and iterate through them */
                e.reader.take(samples);

                for (int i = 0; !e.terminated.getTriggerValue()
                        && i < samples.size(); i++) {
                    if (samples.get(i).getData() != null) {
                        long ph = samples.get(i).getPublicationHandle().hashCode();
                        /* Check that the sample is the next one expected */
                        if (startCount.get(ph) == null && count.get(ph) == null) {
                            count.put(ph, samples.get(i).getData().count);
                            startCount.put(ph, samples.get(i).getData().count);
                        }
                        if (samples.get(i).getData().count != count.get(ph)) {
                            outOfOrder++;
                        }
                        count.put(ph, samples.get(i).getData().count + 1);

                        /* Add the sample payload size to the total received */
                        payloadSize = samples.get(i).getData().payload.length;
                        received += payloadSize + 8;
                    }
                }

                /*
                 * Check that at least one second has passed since the last
                 * output
                 */
                time = ExampleUtilities.GetTime();
                if (time > prevTime + ExampleUtilities.US_IN_ONE_SEC) {
                    /* If not the first iteration */
                    if (prevTime > 0) {
                        /*
                         * Calculate the samples and bytes received and the time
                         * passed since the last iteration and output
                         */
                        DecimalFormat numberFormat = new DecimalFormat("#.00");
                        long deltaReceived = received - prevReceived;
                        double deltaTime = (double) (time - prevTime)
                                / ExampleUtilities.US_IN_ONE_SEC;

                        System.out
                                .println("Payload size: "
                                        + payloadSize
                                        + " | "
                                        + "Total received: "
                                        + samplesReceived(count, startCount,
                                                false)
                                        + " samples, "
                                        + received
                                        + " bytes | "
                                        + "Out of order: "
                                        + outOfOrder
                                        + " samples | "
                                        + "Transfer rate: "
                                        + numberFormat
                                                .format((double) samplesReceived(
                                                        count, prevCount, true)
                                                        / deltaTime)
                                        + " samples/s, "
                                        + numberFormat
                                                .format(((double) deltaReceived / BYTES_PER_SEC_TO_MEGABITS_PER_SEC)
                                                        / deltaTime)
                                        + " Mbit/s");

                        cycles++;
                    } else {
                        /* Set the start time if it is the first iteration */
                        prevCount = startCount;
                        startTime = time;
                    }
                    /* Update the previous values for next iteration */
                    prevReceived = received;
                    prevTime = time;
                }
            }
            /* Output totals and averages */
            double deltaTime = (double) (time - startTime)
                    / ExampleUtilities.US_IN_ONE_SEC;
            System.out.println("\nTotal received: "
                    + samplesReceived(count, startCount, false) + " samples, "
                    + received + " bytes\n" + "Out of order: " + outOfOrder
                    + " samples\n" + "Average transfer rate: "
                    + (double) samplesReceived(count, startCount, false)
                    / deltaTime + " samples/s, "
                    + ((double) received / BYTES_PER_SEC_TO_MEGABITS_PER_SEC)
                    / deltaTime + " Mbit/s");
            e.participant.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
