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

/************************************************************************
 * LOGICAL_NAME:    ExtDomainParticipantHelper.java
 * FUNCTION:        OpenSplice Tutorial example code.
 * MODULE:          Tutorial for the Java programming language.
 * DATE             june 2007.
 ************************************************************************
 * 
 * This file contains the implementation for a Helper class of the extended 
 * DomainParticipant, that simulates the behavior of a Helper class with respect 
 * to narrowing an existing DomainParticipant into its extended representation.
 * 
 ***/

package chatroom;

import DDS.DomainParticipant;

public class ExtDomainParticipantHelper {
    public static ExtDomainParticipant narrow(
            DomainParticipant participant) {
        return new ExtDomainParticipant(participant);
    }
}
