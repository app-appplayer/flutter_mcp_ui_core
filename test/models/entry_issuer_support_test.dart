// `issuer.support` (platform spec 19 §4.1.3): how a person reaches the
// issuer's operator when an entry fails. The resolver answers
// `issuer: {name, verified, support?}` with `support: {url?, phone?, email?}`,
// but `EntryIssuer` carried only `name` and `verified`, so a host lost the
// contact the moment it parsed the answer.

import 'package:flutter_mcp_ui_core/flutter_mcp_ui_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the resolver answer carries support through', () {
    final issuer = EntryIssuer.fromJson({
      'name': 'SafePage QA Tenant',
      'verified': true,
      'support': {
        'url': 'https://safepage.app',
        'phone': '+15555550100',
        'email': 'qa-support@safepage.example',
      },
    });
    expect(issuer.name, 'SafePage QA Tenant');
    expect(issuer.verified, isTrue);
    expect(issuer.support, isNotNull);
    expect(issuer.support!.url, 'https://safepage.app');
    expect(issuer.support!.phone, '+15555550100');
    expect(issuer.support!.email, 'qa-support@safepage.example');
  });

  test('each channel is optional, and none at all is no support', () {
    expect(EntryIssuer.fromJson({'name': 'x', 'support': {'phone': '+821012345678'}})
        .support!
        .email, isNull);
    expect(EntryIssuer.fromJson({'name': 'x'}).support, isNull);
    expect(EntryIssuer.fromJson({'name': 'x', 'support': <String, dynamic>{}}).support,
        isNull, reason: '§4.1.3: at least one when present');
  });

  test('a value outside its form is dropped — the host opens these', () {
    // A host hands them to the operating system (tel: / mailto: / a browser),
    // so `url` is https only and `phone` E.164 only.
    final support = EntryIssuer.fromJson({
      'name': 'x',
      'support': {
        'url': 'javascript:alert(1)',
        'phone': '555-0100',
        'email': 'not-an-address',
      },
    }).support;
    expect(support, isNull);
    expect(
        EntryIssuer.fromJson({
          'name': 'x',
          'support': {'url': 'http://plain.example', 'email': 'ops@example.com'},
        }).support,
        const EntrySupport(email: 'ops@example.com'));
  });

  test('a malformed answer still yields an issuer', () {
    final issuer = EntryIssuer.fromJson({'name': 7, 'support': 'call us'});
    expect(issuer.name, '');
    expect(issuer.verified, isFalse);
    expect(issuer.support, isNull);
  });

  test('support is for the host, not a document binding (§8.1)', () {
    final issuer = EntryIssuer.fromJson({
      'name': 'n',
      'verified': true,
      'support': {'phone': '+15555550100'},
    });
    expect(issuer.toBindingMap(), {'name': 'n', 'verified': true});
  });

  test('equality includes support', () {
    const a = EntryIssuer(
        name: 'n', support: EntrySupport(phone: '+15555550100'));
    const b = EntryIssuer(
        name: 'n', support: EntrySupport(phone: '+15555550100'));
    const c = EntryIssuer(name: 'n');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a == c, isFalse);
  });
}
