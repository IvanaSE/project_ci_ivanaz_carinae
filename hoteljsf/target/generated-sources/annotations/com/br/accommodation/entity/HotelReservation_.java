package com.br.accommodation.entity;

import com.br.accommodation.entity.Bedroom;
import com.br.accommodation.entity.Bill;
import com.br.accommodation.entity.Client;
import com.br.accommodation.entity.ReservationStatus;
import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2017-05-07T16:45:18")
@StaticMetamodel(HotelReservation.class)
public class HotelReservation_ { 

    public static volatile SingularAttribute<HotelReservation, Client> clientId;
    public static volatile SingularAttribute<HotelReservation, BigDecimal> priceDaily;
    public static volatile SingularAttribute<HotelReservation, Date> entryDate;
    public static volatile SingularAttribute<HotelReservation, Bedroom> bedroomId;
    public static volatile SingularAttribute<HotelReservation, ReservationStatus> reservationStatusId;
    public static volatile SingularAttribute<HotelReservation, Bill> bill;
    public static volatile SingularAttribute<HotelReservation, Integer> id;
    public static volatile SingularAttribute<HotelReservation, Date> exitDate;

}