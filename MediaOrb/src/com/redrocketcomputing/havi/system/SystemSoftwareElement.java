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
 * $Id: SystemSoftwareElement.java,v 1.1 2005/02/22 03:44:26 stephen Exp $
 */

package com.redrocketcomputing.havi.system;

import org.havi.system.HaviListener;
import org.havi.system.SoftwareElement;
import org.havi.system.types.HaviMsgException;

/**
 * @author stephen
 *
 */
public class SystemSoftwareElement extends SoftwareElement
{

  /**
   * Constructor for SystemSoftwareElement.
   * @param type
   * @throws HaviGeneralException
   * @throws HaviMsgException
   */
  public SystemSoftwareElement(int type) throws HaviMsgException
  {
    super(type);
  }

  /**
   * Constructor for SystemSoftwareElement.
   * @param haviListener
   * @throws HaviGeneralException
   * @throws HaviMsgException
   */
  public SystemSoftwareElement(int type, HaviListener haviListener) throws HaviMsgException
  {
    super(type, haviListener);
  }

}
