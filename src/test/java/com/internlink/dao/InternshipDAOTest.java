package com.internlink.dao;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

class InternshipDAOTest {

    @Test
    void daoShouldExposeCompanyOwnedInternshipCrudMethods() {
        Class<InternshipDAO> daoClass = InternshipDAO.class;

        assertNotNull(findMethod(daoClass, "insert", com.internlink.model.Internship.class));
        assertNotNull(findMethod(daoClass, "update", com.internlink.model.Internship.class));
        assertNotNull(findMethod(daoClass, "delete", int.class));
        assertNotNull(findMethod(daoClass, "getByCompanyId", int.class));
    }

    private Method findMethod(Class<?> type, String name, Class<?>... parameterTypes) {
        try {
            return type.getDeclaredMethod(name, parameterTypes);
        } catch (NoSuchMethodException e) {
            return null;
        }
    }
}
