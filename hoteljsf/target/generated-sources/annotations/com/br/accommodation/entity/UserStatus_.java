package com.br.accommodation.entity;

import com.br.accommodation.entity.User;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.2.v20140319-rNA", date="2017-05-07T16:45:18")
@StaticMetamodel(UserStatus.class)
public class UserStatus_ { 

    public static volatile SingularAttribute<UserStatus, Integer> code;
    public static volatile CollectionAttribute<UserStatus, User> userCollection;
    public static volatile SingularAttribute<UserStatus, String> name;
    public static volatile SingularAttribute<UserStatus, Integer> id;

}