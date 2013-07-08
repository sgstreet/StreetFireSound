/*
 * Copyright (C) 2004 by StreetFire Sound Labs
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * $Id: FunctionRule.java,v 1.2 2005/02/24 03:03:34 stephen Exp $
 */

package com.streetfiresound.codegenerator.rules;


import java.io.IOException;

import com.streetfiresound.codegenerator.output.WriteAsyncResponseInvocation;
import com.streetfiresound.codegenerator.output.WriteAsyncResponseListener;
import com.streetfiresound.codegenerator.output.WriteRemoteInvocation;
import com.streetfiresound.codegenerator.types.FunctionType;



/**
 * @author george
 *
 */
public class FunctionRule extends RuleDefinition
{

  /**
   * Constructor for FunctionRule.
   */
  public FunctionRule(FunctionType it)
  {
    super(it);
  }

  /**
   * @see com.streetfiresound.codegenerator.rules.RuleOutput#outputToFile()
   */
  public void outputToFile(java.io.OutputStream ostream) throws IOException
  {

      FunctionType ft = (FunctionType) ht;

        //create AsyncResponseListen file
        new WriteAsyncResponseListener((FunctionType) ht);

        //create AsyncResponseInvocation file
        new WriteAsyncResponseInvocation((FunctionType) ht);


        //create RemoteInvocation file
        new WriteRemoteInvocation((FunctionType) ht);


  }






}
