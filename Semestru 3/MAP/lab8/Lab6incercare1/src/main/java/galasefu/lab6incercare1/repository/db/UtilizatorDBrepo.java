package galasefu.lab6incercare1.repository.db;

import galasefu.lab6incercare1.domain.Utilizator;
import galasefu.lab6incercare1.domain.validators.UtilizatorValidator;
import galasefu.lab6incercare1.domain.validators.Validator;
import galasefu.lab6incercare1.repository.Repository;

import java.sql.*;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class UtilizatorDBrepo implements Repository<Long, Utilizator> {
    private String DBurl;
    private String DBusername;
    private String DBpassword;
    Validator<Utilizator> validator = new UtilizatorValidator();

    public UtilizatorDBrepo(String DBurl, String DBpassword, String DBusername, Validator<Utilizator> validator) {
        this.DBurl = DBurl;
        this.DBpassword = DBpassword;
        this.DBusername = DBusername;
        this.validator = validator;
    }

    private Utilizator createUtilizatorfromResultSet(ResultSet resultSet) {
        try {
            Long id = resultSet.getLong("id");
            String nume = resultSet.getString("nume");
            String prenume = resultSet.getString("prenume");
            String email = resultSet.getString("email");
            String password = resultSet.getString("password");


            Utilizator u1 = new Utilizator(nume, prenume, email, password);
            u1.setId(id);
            return u1;
        } catch (SQLException e) {
            System.err.println("Utilizatorul nu a putut fi creat" + e.getMessage());
            return null;
        }

    }


    @Override
    public Optional<Utilizator> findOne(Long id) {
        Utilizator user;
        String sql = "select * from utilizatori U where U.id = ?";
        try (Connection connection = DriverManager.getConnection(DBurl, DBusername, DBpassword);
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet resultSet = ps.executeQuery();
            if (resultSet.next()) {
                user = createUtilizatorfromResultSet(resultSet);
                return Optional.ofNullable(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return Optional.empty();
    }


    @Override
    public Iterable<Utilizator> findAll() {
        Set<Utilizator> users = new HashSet<>();
        Utilizator user;
        try (Connection connection = DriverManager.getConnection(DBurl, DBusername, DBpassword);
             PreparedStatement ps = connection.prepareStatement("select * from utilizatori");
             ResultSet resultSet = ps.executeQuery()) {

            while (resultSet.next()) {
                user = createUtilizatorfromResultSet(resultSet);
                users.add(user);
            }
            return users;


        } catch (SQLException e) {
            e.printStackTrace();
        }


        return users;
    }

    @Override
    public Optional<Utilizator> save(Utilizator u) {

        String sql = "insert into utilizatori (nume, prenume, email, password) values(?, ?, ?, ?)";
        validator.validate(u);

        String checksql = "select count(*) from utilizatori where email = ? or nume = ?";

        try (Connection connection = DriverManager.getConnection(DBurl, DBusername, DBpassword);
             PreparedStatement ps = connection.prepareStatement(sql);
             PreparedStatement check = connection.prepareStatement(checksql)) {


            check.setString(1, u.getEmail());
            check.setString(2, u.getNume());
            ResultSet resultSet = check.executeQuery();
            if (resultSet.next() && resultSet.getInt(1) > 0) {
                System.out.println("Email or name are used by other user");
                return Optional.of(u);
            }


            ps.setString(1, u.getNume());
            ps.setString(2, u.getPrenume());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Connection failed: " + e.getMessage());
            return Optional.ofNullable(u);
        }
        return Optional.empty();
    }

    public Optional<Utilizator> delete(Long id) {
        String deletesql = "delete from utilizatori where id = ?";

        try (Connection connection = DriverManager.getConnection(DBurl, DBusername, DBpassword);
             PreparedStatement ps = connection.prepareStatement(deletesql)) {

            Optional<Utilizator> user = findOne(id);
            if (!user.isEmpty()) {
                ps.setLong(1, id);
                ps.executeUpdate();
            }
            return user;

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return Optional.empty();
    }


    @Override
    public Optional<Utilizator> update(Utilizator user) {
        String sql = "update utilizatori set nume = ?,prenume = ?,email = ?,password = ? where id = ?";
        try (Connection connection = DriverManager.getConnection(DBurl, DBusername, DBpassword);
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getNume());
            ps.setString(2, user.getPrenume());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setLong(5, user.getId());
            if (ps.executeUpdate() > 0) {
                return Optional.empty();
            }
            return Optional.ofNullable(user);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }


}
