package lab5.repository.database;

import lab5.domain.Prietenie;
import lab5.domain.validators.Validator;
import lab5.repository.Repository;

import java.sql.*;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class PrietenieDbRepository implements Repository<Long, Prietenie> {
    private String url;
    private String username;
    private String password;
    private Validator<Prietenie> validator;

    public PrietenieDbRepository(String url, String username, String password, Validator<Prietenie> validator) {
        this.url = url;
        this.username = username;
        this.password = password;
        this.validator = validator;
    }

    @Override
    public Optional<Prietenie> findOne(Long aLong) {
        // Căutăm o prietenie pe baza ID-ului
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("SELECT * FROM \"Friendships\" WHERE id = ?")) {
            statement.setLong(1, aLong);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                Long id = resultSet.getLong("id");
                Long idU1 = resultSet.getLong("idU1");
                Long idU2 = resultSet.getLong("idU2");
                Prietenie prietenie = new Prietenie(idU1, idU2);
                prietenie.setId(id);
                return Optional.of(prietenie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public Iterable<Prietenie> findAll() {
        Set<Prietenie> prietenii = new HashSet<>();
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("SELECT * FROM \"Friendships\"");
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Long id = resultSet.getLong("id");
                Long idU1 = resultSet.getLong("idU1");
                Long idU2 = resultSet.getLong("idU2");

                Prietenie prietenie = new Prietenie(idU1, idU2);
                prietenie.setId(id);
                prietenii.add(prietenie);
            }
            return prietenii;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prietenii;
    }

    @Override
    public Optional<Prietenie> save(Prietenie entity) {
        // Salvăm o prietenie în baza de date
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement(
                     "INSERT INTO \"Friendships\" (\"id\", \"idU1\", \"idU2\") VALUES (?,?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1,entity.getId().intValue());
            statement.setLong(2, entity.getIdU1());
            statement.setLong(3, entity.getIdU2());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                // Obținem ID-ul generat pentru prietenia inserată
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    Long generatedId = generatedKeys.getLong(1);
                    entity.setId(generatedId);
                    return Optional.of(entity);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public Optional<Prietenie> delete(Long aLong) {
        // Ștergem o prietenie pe baza ID-ului
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("DELETE FROM \"Friendships\" WHERE id = ?")) {
            statement.setLong(1, aLong);
            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                return Optional.empty();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public Optional<Prietenie> update(Prietenie entity) {
        // Actualizăm o prietenie (dacă este necesar)
        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement(
                     "UPDATE \"Friendships\" SET \"idU1\" = ?, \"idU2\" = ? WHERE \"id\" = ?")) {
            statement.setLong(1, entity.getIdU1());
            statement.setLong(2, entity.getIdU2());
            statement.setLong(3, entity.getId());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                return Optional.of(entity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }
}
