-- creo una tabella temporanea per estrarre l'età dei clienti con il comando timestampdiff

create temporary table temp_eta as 
select id_cliente,
timestampdiff(year, data_nascita, curdate()) as eta
from cliente;
select * from temp_eta; 

-- creo una tabella temporanea per contare il numero di transazioini in uscita per su tutti i conti
create temporary table temp_num_trans_uscita as
select c.id_cliente,
count(t.id_tipo_trans) as num_trans_uscita
from cliente c
join conto co on c.id_cliente = co.id_cliente  
join transazioni t on co.id_conto = t.id_conto  
join tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where tt.segno = '-'
group by c.id_cliente;
select * from temp_num_trans_uscita;

-- creo una tabella temporanea per contare il numero di transazioini in entrata per su tutti i conti
create temporary table temp_num_trans_entrata as
select c.id_cliente, 
count(t.id_tipo_trans) as num_trans_entrata
from cliente c
join conto co on c.id_cliente = co.id_cliente  
join transazioni t on co.id_conto = t.id_conto  
join tipo_transazione tt on t.id_tipo_trans = tt.id_tipo_transazione
where tt.segno = '+'
group by c.id_cliente;
select * from temp_num_trans_entrata;


-- importo transato in uscita su tutti i conti
CREATE TEMPORARY TABLE temp_importo_trans_uscita AS
SELECT c.id_cliente,
ROUND(SUM(t.importo), 2) AS importo_trans_uscita
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '-'
GROUP BY c.id_cliente;
select * from temp_importo_trans_uscita;

-- importo transato in entrata su tutti i conti
CREATE TEMPORARY TABLE temp_importo_trans_entrata AS
SELECT c.id_cliente,
ROUND(SUM(t.importo), 2) AS importo_trans_entrata
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '+'
GROUP BY c.id_cliente;
select * from temp_importo_trans_entrata;


-- numero totale dei conti posseduti dai clienti
CREATE TEMPORARY TABLE temp_num_conti_posseduti AS
SELECT c.id_cliente,
       COUNT(co.id_conto) AS num_conti_posseduti
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
GROUP BY c.id_cliente;
select * from temp_num_conti_posseduti;


-- Numero di conti posseduti per tipologia
select * from tipo_conto; -- verifico quali tipologie di conto ci sono

CREATE TEMPORARY TABLE temp_num_conti_per_tipologia AS
SELECT c.id_cliente,
       COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN co.id_conto END) AS num_conto_base,
       COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN co.id_conto END) AS num_conto_business,
	   COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN co.id_conto END) AS num_conto_privati,
	   COUNT(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN co.id_conto END) AS num_conto_famiglie
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
GROUP BY c.id_cliente;
select * from temp_num_conti_per_tipologia;


-- numero di transazioni in uscita per tipologia
select * from tipo_transazione; -- controllo le tipologie di transazioni

CREATE TEMPORARY TABLE temp_num_trans_uscita_per_tipologia AS
SELECT c.id_cliente,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Stipendio' THEN t.id_tipo_trans END) AS num_stipendio_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Pensione' THEN t.id_tipo_trans END) AS num_pensione_uscita,
	   COUNT(CASE WHEN tt.desc_tipo_trans = 'Dividendi' THEN t.id_tipo_trans END) AS num_dividendi_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Acquisto su Amazon' THEN t.id_tipo_trans END) AS num_acquisto_amazon_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Rata mutuo' THEN t.id_tipo_trans END) AS num_rata_mutuo_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Hotel' THEN t.id_tipo_trans END) AS num_hotel_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Biglietto aereo' THEN t.id_tipo_trans END) AS num_biglietto_aereo_uscita,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Supermercato' THEN t.id_tipo_trans END) AS num_supermercato_uscita
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '-'
GROUP BY c.id_cliente;
select * from temp_num_trans_uscita_per_tipologia;

-- numero di transazioni in entrata per tipologia
CREATE TEMPORARY TABLE temp_num_trans_entrata_per_tipologia AS
SELECT c.id_cliente,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Stipendio' THEN t.id_tipo_trans END) AS num_stipendio_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Pensione' THEN t.id_tipo_trans END) AS num_pensione_entrata,
	   COUNT(CASE WHEN tt.desc_tipo_trans = 'Dividendi' THEN t.id_tipo_trans END) AS num_dividendi_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Acquisto su Amazon' THEN t.id_tipo_trans END) AS num_acquisto_amazon_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Rata mutuo' THEN t.id_tipo_trans END) AS num_rata_mutuo_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Hotel' THEN t.id_tipo_trans END) AS num_hotel_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Biglietto aereo' THEN t.id_tipo_trans END) AS num_biglietto_aereo_entrata,
       COUNT(CASE WHEN tt.desc_tipo_trans = 'Supermercato' THEN t.id_tipo_trans END) AS num_supermercato_entrata
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '+'
GROUP BY c.id_cliente;
select* from temp_num_trans_entrata_per_tipologia;


-- importo transato in uscita per tipologia conto
CREATE TEMPORARY TABLE temp_importo_uscita_per_tipologia_conto AS
SELECT c.id_cliente,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN t.importo END), 2) AS importo_uscita_conto_base,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN t.importo END), 2) AS importo_uscita_conto_business,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN t.importo END), 2) AS importo_uscita_conto_privati,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo END), 2) AS importo_uscita_conto_famiglie
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '-'
GROUP BY c.id_cliente;
select * from temp_importo_uscita_per_tipologia_conto;

-- importo transato in entrata per tipologia conto
CREATE TEMPORARY TABLE temp_importo_entrata_per_tipologia_conto AS
SELECT c.id_cliente,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Base' THEN t.importo END), 2) AS importo_entrata_conto_base,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Business' THEN t.importo END), 2) AS importo_entrata_conto_business,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Privati' THEN t.importo END), 2) AS importo_entrata_conto_privati,
       ROUND(SUM(CASE WHEN tc.desc_tipo_conto = 'Conto Famiglie' THEN t.importo END), 2) AS importo_entrata_conto_famiglie
FROM cliente c
JOIN conto co ON c.id_cliente = co.id_cliente
JOIN transazioni t ON co.id_conto = t.id_conto
JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
JOIN tipo_transazione tt ON t.id_tipo_trans = tt.id_tipo_transazione
WHERE tt.segno = '+'
GROUP BY c.id_cliente;
select * from temp_importo_entrata_per_tipologia_conto;


-- creo un unica tabella con tutte le indicazioni precedenti 

CREATE TEMPORARY TABLE temp_info_clienti AS
SELECT 
    c.id_cliente,
    c.nome,
    c.cognome,
    c.data_nascita,
    COALESCE(e.eta, 0) as eta,
    COALESCE(tnu.num_trans_uscita, 0) as num_trans_uscita,
    COALESCE(tne.num_trans_entrata, 0) as num_trans_entrata,
    COALESCE(tiu.importo_trans_uscita, 0) as importo_trans_uscita,
    COALESCE(tie.importo_trans_entrata, 0) as importo_trans_entrata,
    COALESCE(tnc.num_conti_posseduti, 0) as num_conti_posseduti,
    COALESCE(tctp.num_conto_base, 0) as num_conto_base,
    COALESCE(tctp.num_conto_business, 0) as num_conto_business,
    COALESCE(tctp.num_conto_privati, 0) as num_conto_privati,
    COALESCE(tctp.num_conto_famiglie, 0) as num_conto_famiglie,
    COALESCE(tnut.num_stipendio_uscita, 0) as num_stipendio_uscita,
    COALESCE(tnut.num_pensione_uscita, 0) as num_pensione_uscita,
    COALESCE(tnut.num_dividendi_uscita, 0) as num_dividendi_uscita,
    COALESCE(tnut.num_acquisto_amazon_uscita, 0) as num_acquisto_amazon_uscita,
    COALESCE(tnut.num_rata_mutuo_uscita, 0) as num_rata_mutuo_uscita,
    COALESCE(tnut.num_hotel_uscita, 0) as num_hotel_uscita,
    COALESCE(tnut.num_biglietto_aereo_uscita, 0) as num_biglietto_aereo_uscita,
    COALESCE(tnut.num_supermercato_uscita, 0) as num_supermercato_uscita,
    COALESCE(tnet.num_stipendio_entrata, 0) as num_stipendio_entrata,
    COALESCE(tnet.num_pensione_entrata, 0) as num_pensione_entrata,
    COALESCE(tnet.num_dividendi_entrata, 0) as num_dividendi_entrata,
    COALESCE(tnet.num_acquisto_amazon_entrata, 0) as num_acquisto_amazon_entrata,
    COALESCE(tnet.num_rata_mutuo_entrata, 0) as num_rata_mutuo_entrata,
    COALESCE(tnet.num_hotel_entrata, 0) as num_hotel_entrata,
    COALESCE(tnet.num_biglietto_aereo_entrata, 0) as num_biglietto_aereo_entrata,
    COALESCE(tnet.num_supermercato_entrata, 0) as num_supermercato_entrata,
    COALESCE(tiutc.importo_uscita_conto_base, 0) as importo_uscita_conto_base,
    COALESCE(tiutc.importo_uscita_conto_business, 0) as importo_uscita_conto_business,
    COALESCE(tiutc.importo_uscita_conto_privati, 0) as importo_uscita_conto_privati,
    COALESCE(tiutc.importo_uscita_conto_famiglie, 0) as importo_uscita_conto_famiglie,
    COALESCE(tient.importo_entrata_conto_base, 0) as importo_entrata_conto_base,
    COALESCE(tient.importo_entrata_conto_business, 0) as importo_entrata_conto_business,
    COALESCE(tient.importo_entrata_conto_privati, 0) as importo_entrata_conto_privati,
    COALESCE(tient.importo_entrata_conto_famiglie, 0) as importo_entrata_conto_famiglie
FROM 
    cliente c
LEFT JOIN 
    temp_eta e ON c.id_cliente = e.id_cliente
LEFT JOIN 
    temp_num_trans_uscita tnu ON c.id_cliente = tnu.id_cliente
LEFT JOIN 
    temp_num_trans_entrata tne ON c.id_cliente = tne.id_cliente
LEFT JOIN 
    temp_importo_trans_uscita tiu ON c.id_cliente = tiu.id_cliente
LEFT JOIN 
    temp_importo_trans_entrata tie ON c.id_cliente = tie.id_cliente
LEFT JOIN 
    temp_num_conti_posseduti tnc ON c.id_cliente = tnc.id_cliente
LEFT JOIN 
    temp_num_conti_per_tipologia tctp ON c.id_cliente = tctp.id_cliente
LEFT JOIN 
    temp_num_trans_uscita_per_tipologia tnut ON c.id_cliente = tnut.id_cliente
LEFT JOIN 
    temp_num_trans_entrata_per_tipologia tnet ON c.id_cliente = tnet.id_cliente
LEFT JOIN 
    temp_importo_uscita_per_tipologia_conto tiutc ON c.id_cliente = tiutc.id_cliente
LEFT JOIN 
    temp_importo_entrata_per_tipologia_conto tient ON c.id_cliente = tient.id_cliente;

select * from temp_info_clienti;
