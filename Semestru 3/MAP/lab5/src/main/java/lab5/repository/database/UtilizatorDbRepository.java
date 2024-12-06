package lab5.repository.database;
import lab5.domain.Utilizator;
import lab5.domain.validators.Validator;
import lab5.repository.Repository;

import java.sql.*;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class UtilizatorDbRepository implements Repository<Long, Utilizator> {
    private String url;
    private String username;
    private String password;
    private Validator<Utilizator> validator;

    public UtilizatorDbRepository(String url, String username, String password, Validator<Utilizator> validator) {
        this.url = url;
        this.username = username;
        this.password = password;
        this.validator = validator;
    }
//    @Override
//    public Optional<Utilizator> findOne(Long aLong) {
//        return Optional.empty();
//    }

    @Override
    public Optional<Utilizator> findOne(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID-ul nu poate fi null!");
        }

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement(
                     "SELECT * FROM \"Users\" WHERE \"id\" = ?"
             )
        ) {
            statement.setLong(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    String firstName = resultSet.getString("firstName");
                    String lastName = resultSet.getString("lastName");

                    Utilizator utilizator = new Utilizator(firstName, lastName);
                    utilizator.setId(id);

                    return Optional.of(utilizator);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in findOne(): " + e.getMessage());
            e.printStackTrace();
        }

        return Optional.empty();
    }


    @Override
    public Iterable<Utilizator> findAll() {
        Set<Utilizator> users = new HashSet<>();
        try (Connection connection = DriverManager.getConnection(url, username, password);
             //PreparedStatement statement = connection.prepareStatement("SELECT * from Users");
             PreparedStatement statement = connection.prepareStatement("SELECT * from \"Users\"");
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Long id = resultSet.getLong("id");
                String firstName = resultSet.getString("firstName");
                String lastName = resultSet.getString("lastName");

                Utilizator utilizator = new Utilizator(firstName, lastName);
                utilizator.setId(id);
                users.add(utilizator);
            }
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public Optional<Utilizator> save(Utilizator entity) {
        int rez = -1;
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement(
                     "INSERT INTO \"Users\" (\"id\", \"firstName\", \"lastName\") VALUES (?, ?, ?)"
             )
        ) {
            System.out.println("Saving user: " + entity);
            statement.setInt(1, entity.getId().intValue());
            statement.setString(2, entity.getFirstName());
            statement.setString(3, entity.getLastName());
            statement.executeUpdate();
            System.out.println("User saved successfully.");
        } catch (SQLException e) {
            System.err.println("Error in save(): " + e.getMessage());
            e.printStackTrace();
        }
        if (rez > 0) {
            return null; // Save-ul a reușit
        } else {
            return Optional.ofNullable(entity); // Save-ul a eșuat
        }
    }


    @Override
    public Optional<Utilizator> delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID-ul nu poate fi null!");
        }

        Optional<Utilizator> utilizatorDeSters = findOne(id);
        if (utilizatorDeSters.isPresent()) {
            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement statement = connection.prepareStatement(
                         "DELETE FROM \"Users\" WHERE \"id\" = ?"
                 )
            ) {
                statement.setLong(1, id);
                statement.executeUpdate();
                System.out.println("Utilizator șters cu succes.");
            } catch (SQLException e) {
                System.err.println("Error in delete(): " + e.getMessage());
                e.printStackTrace();
            }
        }

        return utilizatorDeSters;
    }


    @Override
    public Optional<Utilizator> update(Utilizator entity) {
        if (entity == null) {
            throw new IllegalArgumentException("Entitatea nu poate fi null!");
        }

        validator.validate(entity); // Validează entitatea înainte de actualizare

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement(
                     "UPDATE \"Users\" SET \"firstName\" = ?, \"lastName\" = ? WHERE \"id\" = ?"
             )
        ) {
            statement.setString(1, entity.getFirstName());
            statement.setString(2, entity.getLastName());
            statement.setLong(3, entity.getId());

            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Utilizator actualizat cu succes.");
                return Optional.empty(); // Actualizare reușită
            }
        } catch (SQLException e) {
            System.err.println("Error in update(): " + e.getMessage());
            e.printStackTrace();
        }

        return Optional.of(entity); // Dacă actualizarea a eșuat
    }



}
