package com.br.accommodation.entity;

import com.br.accommodation.entity.HotelReservation;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2017-05-07T16:45:18")
@StaticMetamodel(ReservationStatus.class)
public class ReservationStatus_ { 

    public static volatile SingularAttribute<ReservationStatus, Integer> code;
    public static volatile CollectionAttribute<ReservationStatus, HotelReservation> hotelReservationCollection;
    public static volatile SingularAttribute<ReservationStatus, String> name;
    public static volatile SingularAttribute<ReservationStatus, Integer> id;

}