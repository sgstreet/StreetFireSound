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
 * $Id: ServiceException.java,v 1.1 2005/02/22 03:54:48 stephen Exp $
 */

package com.redrocketcomputing.appframework.service;

/**
 * Base class for all service exception
 *
 * @author stephen Jul 15, 2003
 * @version 1.0
 *
 */
public class ServiceException extends RuntimeException
{

	/**
	 * Constructor for ServiceException.
	 */
	public ServiceException()
	{
		super();
	}

	/**
	 * Constructor for ServiceException.
	 * @param detailMessage
	 */
	public ServiceException(String detailMessage)
	{
		super(detailMessage);
	}

}
