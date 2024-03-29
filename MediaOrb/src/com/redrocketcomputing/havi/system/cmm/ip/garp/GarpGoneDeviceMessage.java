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
 * $Id: GarpGoneDeviceMessage.java,v 1.1 2005/02/22 03:44:26 stephen Exp $
 */

package com.redrocketcomputing.havi.system.cmm.ip.garp;

import org.havi.system.types.GUID;
import org.havi.system.types.HaviByteArrayInputStream;
import org.havi.system.types.HaviByteArrayOutputStream;
import org.havi.system.types.HaviMarshallingException;
import org.havi.system.types.HaviUnmarshallingException;
/**
 * Gone device GARP message. Generated when a device leaves the network or some else detects an error with the device
 *
 * @author stephen Jul 23, 2003
 * @version 1.0
 *
 */
class GarpGoneDeviceMessage extends GarpMessage
{
  public final static int MARSHAL_TYPE = 2;

  private GUID guid = null;

  /**
   * Constructor for GarpGoneDeviceMessage.
   */
  public GarpGoneDeviceMessage()
  {
    super();
  }

  /**
   * Constructor for GarpGoneDeviceMessage.
   * @param guid The guid for the message
   */
  public GarpGoneDeviceMessage(GUID guid)
  {
    this.guid = guid;
  }

  /**
   * Constructor for GarpGoneDeviceMessage.
   * @param hbais The input stream to construct the message
   * @throws HaviUnmarshallingException Thrown with a bad message format is detected
   */
  public GarpGoneDeviceMessage(HaviByteArrayInputStream hbais) throws HaviUnmarshallingException
  {
    // Forward to unmarshall
    unmarshal(hbais);
  }

  /**
   * @see java.lang.Object#clone()
   */
  protected Object clone() throws CloneNotSupportedException
  {
    throw new CloneNotSupportedException();
  }

  /**
   * @see java.lang.Object#equals(Object)
   */
  public boolean equals(Object o)
  {
    // Check type
    if (o instanceof GarpGoneDeviceMessage)
    {
      return ((GarpGoneDeviceMessage)o).guid.equals(guid);
    }

    // Wrong type
    return false;
  }

  /**
   * @see java.lang.Object#hashCode()
   */
  public int hashCode()
  {
    return guid.hashCode() + 543989;
  }

  /**
   * @see org.havi.system.types.Marshallable#marshal(HaviByteArrayOutputStream)
   */
  public void marshal(HaviByteArrayOutputStream hbaos) throws HaviMarshallingException
  {
    // Super class marshall
    super.marshal(hbaos);

    // Marshal guid
    guid.marshal(hbaos);
  }

  /**
   * @see org.havi.system.types.Marshallable#unmarshal(HaviByteArrayInputStream)
   */
  public void unmarshal(HaviByteArrayInputStream hbais) throws HaviUnmarshallingException
  {
    // Super class
    super.unmarshal(hbais);

    // Unmarshal guid
    guid = new GUID(hbais);
  }

  /**
   * @see com.redrocketcomputing.havi.system.cmm.ip.garp.GarpMessage#dispatch(GarpMessageHandler)
   */
  public void dispatch(GarpMessageHandler handler)
  {
    // Forward
    handler.handleGoneDevice(guid);
  }

  /**
   * Returns the guid.
   * @return GUID
   */
  public GUID getGuid()
  {
    return guid;
  }

  /**
   * Sets the guid.
   * @param guid The guid to set
   */
  public void setGuid(GUID guid)
  {
    this.guid = guid;
  }

  /**
   * @see java.lang.Object#toString()
   */
  public String toString()
  {
    return "GoneGuidGarpMessage: " + guid.toString();
  }

}
