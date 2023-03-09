-- USO DE RECORD -------------------------



-- USO DE ESTRUTURA DE DADOS DO TIPO TABLE -------------------------



-- BLOCO ANÔNIMO -------------------------



-- CREATE PROCEDURE -------------------------



-- CREATE FUNCTION -------------------------



-- %TYPE -------------------------
-- Essa consulta seleciona os dados da tabela Usuario para um usuário específico 
DECLARE
v_email_usuario Usuario.email_usuario%TYPE;
v_data_assinatura Usuario.data_assinatura%TYPE;
v_numero_postagens Usuario.numero_postagens%TYPE;
BEGIN
SELECT u.email_usuario, u.data_assinatura, u.numero_postagens
INTO v_email_usuario, v_data_assinatura, v_numero_postagens
FROM Usuario u
WHERE u.email_usuario = 'nivan@cin.ufpe.br';

DBMS_OUTPUT.PUT_LINE('Email do usuário: ' || v_email_usuario);
DBMS_OUTPUT.PUT_LINE('Data da assinatura: ' || TO_CHAR(v_data_assinatura, 'DD/MM/YYYY'));
DBMS_OUTPUT.PUT_LINE('Número de postagens: ' || v_numero_postagens);
END;
/


-- %ROWTYPE -------------------------
-- utilizamos a variável v_usuario do tipo %ROWTYPE para armazenar todas as colunas da tabela Usuario referentes a um usuário específico ('silvio@cin.ufpe.br'). Em seguida, contamos quantos seguidores esse usuário tem e armazenamos o resultado na variável v_seguidores. Finalmente, imprimimos os dados do usuário (email, data da assinatura, número de postagens) e o número de seguidores usando a função DBMS_OUTPUT.PUT_LINE(
DECLARE
v_usuario Usuario%ROWTYPE;
v_seguidores INTEGER;
BEGIN
SELECT *
INTO v_usuario
FROM Usuario u
WHERE u.email_usuario = 'silvio@cin.ufpe.br';

SELECT COUNT(*) INTO v_seguidores
FROM Segue s
WHERE s.seguido = v_usuario.email_usuario;

DBMS_OUTPUT.PUT_LINE('Dados do usuário:');
DBMS_OUTPUT.PUT_LINE('Email: ' || v_usuario.email_usuario);
DBMS_OUTPUT.PUT_LINE('Data da assinatura: ' || TO_CHAR(v_usuario.data_assinatura, 'DD/MM/YYYY'));
DBMS_OUTPUT.PUT_LINE('Número de postagens: ' || v_usuario.numero_postagens);
DBMS_OUTPUT.PUT_LINE('Seguidores: ' || v_seguidores);
END;
/

-- IF ELSIF -------------------------



-- CASE WHEN -------------------------
-- seleciona o número de postagens do usuário com o email 'nivan@cin.ufpe.br' da tabela Usuario e, em seguida, utiliza uma estrutura CASE WHEN para imprimir uma mensagem de acordo com o número de postagens desse usuário. Se o número de postagens for maior que 50, a mensagem "Este usuário é um usuário ativo e experiente." é impressa; se o número de postagens for maior que 20 e menor ou igual a 50, a mensagem "Este usuário é um usuário moderado." é impressa; caso contrário, a mensagem "Este usuário é um usuário iniciante." é impressa
DECLARE
  v_numero_postagens Usuario.numero_postagens%TYPE;
BEGIN
  SELECT numero_postagens INTO v_numero_postagens FROM Usuario WHERE email_usuario = 'nivan@cin.ufpe.br';
  
  CASE 
    WHEN v_numero_postagens > 50 THEN 
      DBMS_OUTPUT.PUT_LINE('Este usuário é um usuário ativo e experiente.');
    WHEN v_numero_postagens > 20 AND v_numero_postagens <= 50 THEN
      DBMS_OUTPUT.PUT_LINE('Este usuário é um usuário moderado.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Este usuário é um usuário iniciante.');
  END CASE;
END;



-- LOOP EXIT WHEN ------------------------- [OK]
-- Lista o nome dos usuários e quais as postagens que eles fizeram

DECLARE
  v_nome perfil.nome%TYPE;
  v_titulo_postagem postagem.titulo_da_postagem%TYPE;

CURSOR cursor_postagem IS
  SELECT pf.nome, pt.titulo_da_postagem
  FROM perfil pf, postagem pt
  WHERE pf.email = pt.usuario_associado;

BEGIN
  OPEN cursor_postagem;
  LOOP
    FETCH cursor_postagem into v_nome, v_titulo_postagem;
    EXIT WHEN cursor_postagem%NOTFOUND;
    dbms_output.put_line('O usuário '|| TO_CHAR(v_nome)|| ' fez a postagem ' ||TO_CHAR(v_titulo_postagem));
  END LOOP;
  CLOSE cursor_postagem;
  EXCEPTION
  WHEN INVALID_CURSOR THEN
    DBMS_OUTPUT.put_line('Erro!');
END;


-- WHILE LOOP ------------------------- [OK]
-- Mostra quantos usuários cada moderador já baniu, e incrementa o valor total de contas banidas a cada iteração do while loop.
DECLARE
   total INTEGER := 0;
   email moderador.email_moderador%TYPE;
   banidas moderador.num_contas_banidas%TYPE;
BEGIN
  SELECT email_moderador, num_contas_banidas INTO email, banidas FROM moderador 
  ORDER BY email_moderador
  FETCH FIRST 1 ROWS ONLY;
   
  WHILE email IS NOT NULL LOOP
    dbms_output.put_line('Usuário [' || email || '] baniu ' || banidas ||' contas');
    total := total + banidas;
    
    BEGIN
        SELECT email_moderador, num_contas_banidas INTO email, banidas FROM moderador WHERE email_moderador > email ORDER BY email_moderador FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          email := NULL;
          banidas := NULL;
    END;
   END LOOP;
   
   dbms_output.put_line('Número total de contas banidas: ' || total);
END;



-- FOR IN LOOP -------------------------
-- loop FOR IN é utilizado para percorrer todos os usuários da tabela Usuario e somar o número total de postagens de todos eles. O resultado é armazenado na variável v_total_postagens e, em seguida, uma mensagem é impressa na tela com o total de postagens de todos os usuários.

DECLARE
  v_total_postagens NUMBER := 0;
BEGIN
  FOR usuario IN (SELECT email_usuario, numero_postagens FROM Usuario)
  LOOP
    v_total_postagens := v_total_postagens + usuario.numero_postagens;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('O total de postagens de todos os usuários é: ' || v_total_postagens);
END;


-- SELECT ... INTO -------------------------



-- CURSOR (OPEN, FETCH e CLOSE) -------------------------



-- EXCEPTION WHEN -------------------------



-- USO DE PARÂMETROS (IN, OUT ou IN OUT) -------------------------



-- CREATE OR REPLACE PACKAGE -------------------------



-- CREATE OR REPLACE PACKAGE BODY -------------------------



-- CREATE OR REPLACE TRIGGER (COMANDO) -------------------------



-- CREATE OR REPLACE TRIGGER (LINHA) -------------------------

