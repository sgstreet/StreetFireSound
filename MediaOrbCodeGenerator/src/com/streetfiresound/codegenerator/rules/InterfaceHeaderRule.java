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
 * $Id: InterfaceHeaderRule.java,v 1.2 2005/02/24 03:03:34 stephen Exp $
 */

package com.streetfiresound.codegenerator.rules;


import com.streetfiresound.codegenerator.types.InterfaceHeaderType;

/**
 * @author george
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class InterfaceHeaderRule extends RuleDefinition
{

  /**
   * Constructor for InterfaceHeaderRule.
   */
  public InterfaceHeaderRule(InterfaceHeaderType it)
  {
    super(it);
  }

  /**
   * @see com.streetfiresound.codegenerator.rules.RuleOutput#outputToFile()
   */
  public void outputToFile(java.io.OutputStream ostream)throws java.io.IOException
  {

      ostream.write(ht.getTypeName().getBytes());

  }

}
